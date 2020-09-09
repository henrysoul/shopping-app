import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:store/screens/user_product_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class SideDrawer extends StatelessWidget {
  Widget menuItem(String text, context,IconData icon, Function menuItemFunction) {
    return Container(
      // color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          ListTile(
            leading:Icon(icon),
            title: Text(
              text,
              style: TextStyle(color:Colors.grey),
            ),
            onTap: menuItemFunction,
          ),
          Divider()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          AppBar(
            title: Text('Store'),
            // this removes back button from the sdide drawer
            automaticallyImplyLeading: false,
          ),
          menuItem(
            'Shop',
            context,
            Icons.shop,
            () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          menuItem(
            'Orders',
            context,
            Icons.payment,
            () {
              Navigator.of(context)
                  .pushReplacement(CustomRoute(builder: (ctx) => OrdersScreen()));
                  // .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          menuItem(
            'Cart',
            context,
            Icons.shopping_cart,
            () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),menuItem(
            'Manage Product',
            context,
            Icons.edit,
            () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
          ),
          menuItem(
            'Logout',
            context,
            Icons.exit_to_app,
            () {
              // pop the drawer before logging out
              Navigator.of(context).pop();
              Provider.of<Auth>(context,listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
