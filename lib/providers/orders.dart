import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:store/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

// we wanna listen to the changess
class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    // spread so _orders cannot be changed from outside this class
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    // .add adds at the ending of the list; insert(index,elemnt) adds at the begining of the list
    // i want more recent orders to be at the begining of the list
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
