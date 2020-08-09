import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            // i added intel package in pubspec.yaml for date formatting used belowv
            subtitle: Text(
              DateFormat('dd MM yy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          // the height depends on the number of items in the list, the height is calculated automatically i import math.dart to use
          if (_expanded)
            Container( 
              padding: EdgeInsets.symmetric(horizontal:15,vertical:4),
              height: min(widget.order.products.length * 20.0 + 10.0, 100.0),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
                            ),
                            Text('${prod.quantity}x \$${prod.price}',style: TextStyle(fontSize:18,color:Colors.grey),)
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
