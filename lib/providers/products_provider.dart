import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  Future<void> fetchAndSetProducts() async {
    const url = 'https://shop-19e29.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      // i throw so it can be handled in the widget
      throw error;
    }
  }

  List<Product> get items {
    return [..._items];
  }

// this returns a type product
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

// the alternative of running this is using then,catchError which is commented below

// implementing the future using async and wait and try and catch for handling the error
// i wanna return type future
  Future<void> addProduct(Product product) async {
    const url = 'https://shop-19e29.firebaseio.com/products.json';
    try {
      // i saved this in response because http retuns something
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'price': product.price
        }),
      );

      final newProduct = Product(
        // because the name is a unique key from the response
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      // not insert adds to the beginig add adds to the end
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // i wanna return type future
  // Future<void> addProduct(Product product) {
  //   const url = 'https://shop-19e29.firebaseio.com/products.json';
  //   // json.encode receive a map
  //   // i wanna a add a loader in the widget before futrure below is completed and remove it after completion
  //   // so for that i  http returns a future so i am gonna put return infront of http and use the future where
  //   // the method in the provider is called
  //   return http
  //       .post(
  //     url,
  //     body: json.encode({
  //       'title': product.title,
  //       'description': product.description,
  //       'imageUrl': product.imageUrl,
  //       'isFavorite': product.isFavorite,
  //       'price': product.price
  //     }),
  //   )
  //   .then<void>((response) {
  //     // i used promise to update the screen after adding the product
  //     final newProduct = Product(
  //       // id: DateTime.now().toString(),
  //       // because the name is a unique key from the response
  //       id: json.decode(response.body)['name'],
  //       title: product.title,
  //       description: product.description,
  //       imageUrl: product.imageUrl,
  //       price: product.price,
  //     );
  //     _items.add(newProduct);
  //     // not insert adds to the beginig add adds to the end
  //     notifyListeners();
  //   }).catchError((error) {
  //     // i throw the error so i can catch it in the editproductscreen
  //     throw error;
  //   });
  // }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-19e29.firebaseio.com/products/$id.json';
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl
          // i am not sending isFavorite cos i dont wanna overide what i have before
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) {
    final url = 'https://shop-19e29.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    // note this removes from the list and not from memeory
    _items.removeAt(existingProductIndex);
    notifyListeners();

    return http.delete(url).then<void>((reponse) {
      // read more about http error handling form docs
      if (reponse.statusCode >= 400) {
        //  i needed to throw in catch here so i can be able to catch below
        throw HttpException("Could not delete product");
      }
      existingProduct = null;
    }).catchError((error) {
      //  i wanna add back the remvoed item if there is an http error optimistic updating
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw error;
    });

    // _items.removeWhere((prod) => prod.id == id);
  }
}
