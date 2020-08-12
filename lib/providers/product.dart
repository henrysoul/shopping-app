import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    this.isFavorite = false,
    @required this.price,
  });

  void setValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }
  Future<void> toggleFavoriteStatus() async {
    final url = 'https://shop-19e29.firebaseio.com/products/$id.json';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      // http only throws error for post and get you need to handle the error for patch put etc
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        setValue(oldStatus);
      }
    } catch (error) {
      setValue(oldStatus);
    }
  }
}
