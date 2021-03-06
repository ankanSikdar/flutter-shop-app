import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String auth;
  List<Product> _items;
  final String userId;

  Products([this.auth, this.userId, this._items = const []]);

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProducts({fetchByUserId = false}) async {
    final filterString =
        fetchByUserId ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-shop-app-69896.firebaseio.com/products.json?auth=$auth&$filterString';

    try {
      final response = await http.get(url);
      Map data = json.decode(response.body);
      if (data == null || data['error'] != null) {
        throw HTTPException(
            data == null ? 'Something went wrong!' : data['error']);
      }
      url =
          'https://flutter-shop-app-69896.firebaseio.com/userFavorites/$userId.json?auth=$auth';
      final favorites = await http.get(url);
      Map favoritesData = json.decode(favorites.body);

      List<Product> downloadedProducts = [];
      data.forEach((prodId, prodData) {
        downloadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoritesData == null ? false : favoritesData[prodId] ?? false,
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
    String url =
        'https://flutter-shop-app-69896.firebaseio.com/products.json?auth=$auth';

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
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
        'https://flutter-shop-app-69896.firebaseio.com/products/$id.json?auth=$auth';
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
        'https://flutter-shop-app-69896.firebaseio.com/products/$id.json?auth=$auth';
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
