import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart' as OrderProvider;

class OrderItem extends StatefulWidget {
  final OrderProvider.OrderItem orderItem;

  OrderItem({this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            '₹ ${widget.orderItem.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            DateFormat.yMd().add_jm().format(widget.orderItem.dateTime),
            style: TextStyle(
              fontSize: 15,
            ),
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
        if (_expanded)
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            height: min(widget.orderItem.products.length * 20.0 + 10, 100.0),
            child: ListView.builder(
              // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.orderItem.products[index].title}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${widget.orderItem.products[index].quantity}X ₹${widget.orderItem.products[index].price}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
              itemCount: widget.orderItem.products.length,
            ),
          ),
      ],
    );
  }
}
