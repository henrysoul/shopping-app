import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/providers/products_provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/side_drawer.dart';
import '../providers/products_provider.dart';

enum filterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showOnlyFavorites = false;
  var firstBuild = true;
  var isLoading = false;


  //  i should have used intState to fetch the products but init statte doesnot receive conntext directly 
  // cos dart does not know what the state is after building so i used didChangeDependencies 
  // there is a way to use inint state for this check orders_screen.dart
  @override
  void didChangeDependencies() {
    if (firstBuild) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    firstBuild = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filterOptions selectedValue) {
              setState(() {
                if (selectedValue == filterOptions.Favorites) {
                  showOnlyFavorites = true;
                } else {
                  showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: filterOptions.Favorites),
              PopupMenuItem(
                child: Text('Show All'),
                value: filterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, theChild) => Badge(
              child: theChild,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: SideDrawer(),
      body:isLoading ? Center(child:CircularProgressIndicator()) : ProductsGrid(showOnlyFavorites),
    );
  }
}