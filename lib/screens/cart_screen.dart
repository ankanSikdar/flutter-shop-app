import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart' show Orders;
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
                  OrderButton(
                    orders: orders,
                    cart: cart,
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.orders,
    @required this.cart,
  }) : super(key: key);

  final Orders orders;
  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isOrdering = false;

  @override
  Widget build(BuildContext context) {
    return _isOrdering
        ? Container(
            height: 25,
            width: 25,
            margin: EdgeInsets.only(left: 10),
            child: CircularProgressIndicator(),
          )
        : IconButton(
            color: Colors.green,
            disabledColor: Colors.grey,
            icon: Icon(
              Icons.check_circle,
              size: 40,
            ),
            onPressed: widget.cart.itemCount <= 0
                ? null
                : () async {
                    setState(() {
                      _isOrdering = true;
                    });
                    try {
                      await widget.orders.addOrder(
                          cartProducts: widget.cart.items.values.toList(),
                          total: widget.cart.totalPrice);
                      widget.cart.clearCart();
                      setState(() {
                        _isOrdering = false;
                      });
                    } catch (error) {
                      setState(() {
                        _isOrdering = false;
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'ERROR: Unable to place order! Try again later!'),
                      ));
                    }
                  },
          );
  }
}
