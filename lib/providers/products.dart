import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/data/product_data.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = data;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) {
    String url = 'https://flutter-shop-app-69896.firebaseio.com/products.json';

    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price.toString(),
              'imageUrl': product.imageUrl,
            }))
        .then((value) {
      Product newProduct = Product(
        id: json.decode(value.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      throw error;
    });
  }

  void updateProduct(String id, Product product) {
    final productIndex = _items.indexWhere((element) => element.id == id);
    _items[productIndex] = Product(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      isFavorite: _items[productIndex].isFavorite,
    );
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
