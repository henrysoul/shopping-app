import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/widgets/side_drawer.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = false;
  var isError = false;
  // context cannot be accessed in initState check read about it
  // but the case is somewhat different for Provider because i can set listen to false
  // if i was use Modal.route where context cannot be set to false then i would use future.delayed in initstate
  // or use didChangeDependencies all this is just to get something before build is executed
  @override
  void initState() {
    // go back to the course lecture 253 for an altenative way of doing this
    // another hack is this widget can be conveerted to a statless one and then use FutureBuilder()
    Future.delayed(Duration.zero).then((_) async {
      try {
        setState(() {
          isLoading = true;
          isError = false;
        });
        await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
        setState(() {
          isLoading = false;
        });
      } catch (error) {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Your Orders')),
        drawer: SideDrawer(),
        body: Stack(
          children: <Widget>[
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!isLoading && !isError)
              ListView.builder(
                itemBuilder: (ctx, i) => ord.OrderItem(orderData.orders[i]),
                itemCount: orderData.orders.length,
              ),
            if (isError)
              Center(
                child: Text('An Error Occured'),
              ),
          ],
        ));
  }
}
