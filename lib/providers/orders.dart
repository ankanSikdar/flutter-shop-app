import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

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

class Orders with ChangeNotifier {
  final String auth;
  final String userId;
  List<OrderItem> _orders;
  Orders([this.auth, this._orders = const [], this.userId]);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    String url =
        'https://flutter-shop-app-69896.firebaseio.com/orders/$userId.json?auth=$auth';

    var response = await http.get(url);
    Map<String, dynamic> orderData = json.decode(response.body);
    if (orderData == null) {
      return;
    }
    List<OrderItem> ordersList = [];
    orderData.forEach((key, value) {
      List<CartItem> productsList = [];
      List prods = value['products'] as List;
      prods.forEach((element) {
        productsList.add(CartItem(
          id: element['id'],
          title: element['title'],
          price: element['price'],
          quantity: element['quantity'],
        ));
      });
      ordersList.add(OrderItem(
        id: key,
        amount: value['amount'],
        products: productsList,
        dateTime: DateTime.parse(value['dateTime']),
      ));
    });

    _orders = ordersList.reversed.toList();
  }

  Future<void> addOrder({List<CartItem> cartProducts, double total}) async {
    String url =
        'https://flutter-shop-app-69896.firebaseio.com/orders/$userId.json?auth=$auth';

    DateTime time = DateTime.now();

    try {
      var response = await http.post(url,
          body: json.encode({
            'amount': total,
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList(),
            'dateTime': time.toIso8601String(),
          }));
      final OrderItem orderItem = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: time,
      );
      _orders.insert(
        0,
        orderItem,
      );
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw HTTPException(error.toString());
    }
  }
}
