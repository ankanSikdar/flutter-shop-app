import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final productIds = cart.items.keys.toList();

    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '₹ ${cart.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                    onPressed: () {
                      orders.addOrder(
                          cartProducts: cart.items.values.toList(),
                          total: cart.totalPrice);
                      cart.clearCart();
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (context, index) {
              return CartItem(
                id: cartItems[index].id,
                productId: productIds[index],
                title: cartItems[index].title,
                price: cartItems[index].price,
                quantity: cartItems[index].quantity,
              );
            },
          ))
        ],
      ),
    );
  }
}
