import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  // i wanna get image before submitting for for preview
  final imageUrlController = TextEditingController();
  final imageUrlFocusNode = FocusNode();

  var editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  var initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

// interracts with they state in the form widget this key need to be attached to the form below
  final form = GlobalKey<FormState>();

  var isInit = true;

  @override
  void initState() {
    imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  //  wanna get the  argumetns from the route, the ineed to get it before buld is executed so i could have used
  //  iniState() but i use didChangeDependencies() because Modal.route cannot be used in init state
  //  if i was using provider i could use initState but i am not using provider to pass the id so didChangeDependencies
  //  is used
  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        editedProduct =
            Provider.of<ProductsProvider>(context).findById(productId);
        // note :used string because textfield only works with string
        initValue = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
          'imageUrl': '',
        };
        imageUrlController.text = editedProduct.imageUrl;
      }
    }
    // because i dont wanna reinitilize the form and didChangeDependencies will run mutiple times
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // the focus node needs to be disposed from the memory else it will be rmebered and focused on when this page is revisited
    // remove the listener before disposing it
    imageUrlFocusNode.removeListener(updateImageUrl);
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlController.dispose();
    imageUrlFocusNode.dispose();

    super.dispose();
  }

  updateImageUrl() {
    if (!imageUrlFocusNode.hasFocus) {
      // validates url
      if (!imageUrlController.text.startsWith('http') &&
          !imageUrlController.text.startsWith('https')) {
        return;
      }
      if (!imageUrlController.text.endsWith('.png') &&
          !imageUrlController.text.endsWith('.jpg') &&
          !imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      // because of the change in the input the state updatestes itself and rerender with the new imageurl view for the preview
      setState(() {});
    }
  }

// i need to get direct access to the form widget to save it so i use a global key
  void saveForm() {
    // valiate form with validator on submit
    final isValid = form.currentState.validate();
    if (!isValid) {
      // stop execution
      return;
    }

    // tiggers a method on every form filed and gets the imageUrlController.text
    form.currentState.save();
    if (editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // column with single child scroll view can be used
          key: form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: initValue['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(priceFocusNode);
                },
                validator: (value) {
                  // return null means everything is ok...return 'string' take the string as the error message
                  // note:: when you add auto validation to your formInput the input runs the validator on every key stroke
                  // its not added for this particular form
                  if (value.isEmpty) {
                    return 'Please enter a imageUrlController.text';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: value,
                    description: editedProduct.description,
                    imageUrl: editedProduct.imageUrl,
                    price: editedProduct.price,
                    isFavorite: editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: initValue['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(descriptionFocusNode);
                },
                validator: (value) {
                  // return null means everything is ok...return 'string' take the string as the error message
                  // note:: when you add auto validation to your formInput the input runs the validator on every key stroke
                  // its not added for this particular form
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: editedProduct.title,
                    description: editedProduct.description,
                    imageUrl: editedProduct.imageUrl,
                    price: double.parse(value),
                    isFavorite: editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: initValue['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                // mulltiline auto gives new line button on the keyboard so i comment out the line below
                // textInputAction:TextInputAction.next,
                focusNode: descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Too short Description';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: editedProduct.title,
                    description: value,
                    imageUrl: editedProduct.imageUrl,
                    price: editedProduct.price,
                    isFavorite: editedProduct.isFavorite,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageUrlController,
                      focusNode: imageUrlFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an Image URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid Image URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please Enter a valid image url';
                        }
                        return null;
                      },
                      // triggered when done button ont the keyboard is pressed
                      // onFieldSubmitted expects a function that takes a string imageUrlController.text that why i didnot point to
                      // my save function directly
                      onFieldSubmitted: (_) {
                        saveForm();
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: editedProduct.title,
                          description: editedProduct.description,
                          imageUrl: value,
                          price: editedProduct.price,
                          isFavorite: editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}