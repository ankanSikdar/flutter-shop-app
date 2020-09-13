import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _changeFavorite(bool state) {
    isFavorite = state;
    notifyListeners();
  }

  Future<void> toggleFavorite({String auth}) async {
    bool oldSate = isFavorite;
    String url =
        'https://flutter-shop-app-69896.firebaseio.com/products/$id.json?auth=$auth';

    _changeFavorite(!isFavorite);

    try {
      var response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        throw HTTPException(
            'Error ${response.statusCode}: Unable to Change Favorite!');
      }
    } catch (error) {
      _changeFavorite(oldSate);
      throw error;
    }
  }
}
