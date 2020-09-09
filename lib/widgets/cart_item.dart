import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final double price;
  final String title;
  final int quantity;

  CartItem({this.id, this.productId, this.title, this.price, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.only(right: 10),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Are you sure?'),
                  titleTextStyle:
                      Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 25,
                            color: Colors.black,
                          ),
                  content: Text('You want to remove $title from the cart?'),
                  actions: [
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(productId: productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                Provider.of<Products>(context).findById(productId).imageUrl,
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
      ),
    );
  }
}
