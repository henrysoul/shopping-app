import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products_provider.dart';
class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;
  ProductsGrid(this.showOnlyFavorites);
  @override
  Widget build(BuildContext context) {
    // to specify the type of data you wanna listen to <>
    final productsProviderData = Provider.of<ProductsProvider>(context);
    
    final products = showOnlyFavorites ? productsProviderData.favoriteItems : productsProviderData.items; 

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      // the product provider is set below wrapped with ChangeNotifierProvder passed to the child widget that needs it and then its accepted in the child widget
      // i am using create to pass the provider because of the version of my flutter i could have used build
      // i passed a single products[i] because one is render at a time in my gridview.builder at a time,
      // check main.dart for how products is passed to this screen widget
      // 
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
          value:products[i] ,
          // this product is now passed to the product details page through the product provider and checked for favorite
          child: ProductItem(
          // products[i].id,
          // products[i].title,
          // products[i].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}