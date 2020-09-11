import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProducts() async {
    String url = 'https://flutter-shop-app-69896.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      Map data = json.decode(response.body);
      List<Product> downloadedProducts = [];
      data.forEach((prodId, prodData) {
        downloadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = downloadedProducts;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    String url = 'https://flutter-shop-app-69896.firebaseio.com/products.json';

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': false,
          }));
      Product newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    String url =
        'https://flutter-shop-app-69896.firebaseio.com/products/$id.json';
    await http.patch(url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }));

    _items[productIndex] = Product(
      id: id,
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      isFavorite: _items[productIndex].isFavorite,
    );
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    int productIndex = _items.indexWhere((element) => element.id == id);
    Product deletedProduct = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();

    String url =
        'https://flutter-shop-app-69896.firebaseio.com/products/$id.json';
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, deletedProduct);
      notifyListeners();
      throw HTTPException(
          'ERROR ${response.statusCode}: Coudn\'t delete product!');
    }
    deletedProduct = null;
  }
}
