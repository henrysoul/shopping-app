import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imagurl;

  UserProductItem(this.id, this.title, this.imagurl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      // background image does not take a image.network but provider(bult in flutter) that yields network inmage
      // you might wanna use asset image if the image is included in your file
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imagurl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(id)
                    .catchError((_) {
                      // the widget context cannot be used in future beacuse dart doest know if the context has changed
                      // before reaching the code so i Scaffold.of(context). in a varaible
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text('Deleting failed'),
                        ),
                      );
                });
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
