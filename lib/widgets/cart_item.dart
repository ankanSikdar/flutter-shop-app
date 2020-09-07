import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String title;
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '₹ $price',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          title: Text(
            '$title',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Total: ₹ ${(quantity * price).toStringAsFixed(2)}'),
          trailing: Text('$quantity X',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
