import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

class BuyFloatingActionButton extends StatelessWidget {
  final Cart cart;
  final String productId;
  final String title;
  final double price;

  BuyFloatingActionButton({this.cart, this.productId, this.title, this.price});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        cart.addItem(
          productId: productId,
          title: title,
          price: price,
        );
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Item Added to Cart!'),
          action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                cart.removeSingleItem(productId: productId);
              }),
        ));
      },
      child: Icon(
        Icons.add_shopping_cart,
        color: Colors.white,
      ),
    );
  }
}
