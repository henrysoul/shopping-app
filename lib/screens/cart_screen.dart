import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/widgets/side_drawer.dart';
import '../providers/orders.dart';
// because of CartItem confilict class on both cart provider and CartItem screen i will shpw ony Cart from cart provider
// because i am not using CartItem from it, i altern alternatively can import cart_item as newname then use newnam.CartItem()
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      drawer: SideDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      // to format amount
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderBotton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          // listview in a column directly does not work so wrap with expanded
          Expanded(
            // the items in the provide is a map so i need to get the values to list so i can get the actual values
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                productId: cart.items.keys.toList()[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderBotton extends StatefulWidget {
  const OrderBotton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderBottonState createState() => _OrderBottonState();
}

class _OrderBottonState extends State<OrderBotton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0 || isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                isLoading = false;
              });
              //clear cart
              widget.cart.clear();
            },
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
            ),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
