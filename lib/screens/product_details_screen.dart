import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class PoductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // i used listen false because this widget would not rebuild in any way because it value cannot change technically its a product details screen
    // whoose value cannot change on the fly i dont want it to rebuild if the event listener notifier changes from the product provider
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      // i changed the body widget from SingleChildScrollView to CustomChildView because i wanna use sliver
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // height it should have if it not the app bar but the image i.e height of the image
            expandedHeight: 300,
            // the appBar should always be visible even when scrolling
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Center(
                child: Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  // wraps to a new line if there is no more space
                  softWrap: true,
                ),
              ),
              // to see the scroll effect
              SizedBox(
                height: 600,
              ),
            ]),
          ),
        ],
        // child: Column(
        //   children: <Widget>[
        //   Container(
        //         height: 300,
        //         width: double.infinity,
        //         child: Hero(
        //           tag: loadedProduct.id,
        //           child: Image.network(
        //             loadedProduct.imageUrl,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        // ],
        // ),
      ),
    );
  }
}
