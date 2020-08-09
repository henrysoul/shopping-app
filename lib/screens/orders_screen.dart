import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/widgets/side_drawer.dart';

import '../providers/orders.dart';
import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: SideDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => ord.OrderItem(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
