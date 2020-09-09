import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/providers/auth.dart';
import 'package:store/screens/auth_screen.dart';
import 'package:store/screens/splash_screen.dart';
import 'package:store/screens/user_product_screen.dart';

import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import 'screens/edit_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  // wrapped with ChangeNotifierProvider and added create because provider is used
  // provider provides an instance of the productProvider class to all child widget which then set a listener to the productprovider class
  // and rebuilds only widgets that are listening and not all the whole material app
  Widget build(BuildContext context) {
    print('main');
    return MultiProvider(
        providers: [
          // this is how the provider is used below, i think it can be consumed from anywhere in this app because its it returns the whole app
          // note there are various ways of implementing provider
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          // Important note:: products_provider. dart now depends on auth provider
          // reason because i need to pass my token which is in auth provider to product provider then send to url
          // that needs it... so to do this i will change my ChangeNotifierProvider to ChangeNotifierProxyProvider
          // for me to be able to pass the token form auth provider to products provider
          // also note::: since products provider depends on auth provider, products provider must be placed below
          // auth provider in the provider list
          // also note products provider migth already be loaded in our screen or whereever before we got to
          // the block that needs the token from auth provider, therefore i need to keep track of the old state of
          // the product provider e.g product provider has list of products and products provider will be rebuit
          // if something changes in auth provider and we need tot keep track of the old state(products in this case)
          // in product provider so we can render the old state..
          // therefore ChangeNotifierProxyProvider will now be implemted below
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token,
              auth.theUserId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          // another method of adding provider
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userId),
          ),
        ],
        // ensure the material app rebuilds when auth object changed ie when notifylisteners() is called
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            // added auto login to check if token exists after user close the app auto login
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                  // tries to auto login by running tryAutoLogin() and updating listners in this case this wdiget rebuilds
                  // and check if auth before actually rendering the AuthScreen()
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              PoductDetailsScreen.routeName: (ctx) => PoductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProduct.routeName: (ctx) => EditProduct(),
            },
          ),
        ));
  }
}
