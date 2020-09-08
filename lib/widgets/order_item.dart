import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart' as OrderProvider;

class OrderItem extends StatelessWidget {
  final OrderProvider.OrderItem orderItem;

  OrderItem({this.orderItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('₹ ${orderItem.amount}'),
      subtitle: Text(DateFormat.yMd().add_jm().format(orderItem.dateTime)),
      trailing: IconButton(
        icon: Icon(Icons.expand_more),
        onPressed: () {},
      ),
    );
  }
}
