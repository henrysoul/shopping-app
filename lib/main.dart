import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  // wrapped with ChangeNotifierProvider and added create because provider is used
  // provider provides an instance of the productProvider class to all child widget which then set a listener to the productprovider class
  // and rebuilds only widgets that are listening and not all the whole material app
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // this is how the provider is used below, i think it can be consumed from anywhere in this app because its it returns the whole app
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        )
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {PoductDetailsScreen.routeName: (ctx) => PoductDetailsScreen()},
      ),
    );
  }
}
