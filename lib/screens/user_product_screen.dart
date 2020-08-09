import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/screens/edit_product_screen.dart';
import 'package:store/widgets/side_drawer.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (ctx, i) => Column(
            children: <Widget>[
              UserProductItem(
                productData.items[i].id,
                productData.items[i].title,
                productData.items[i].imageUrl,
              ),
              Divider(
                thickness: 5,
              ),
            ],
          ),
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
