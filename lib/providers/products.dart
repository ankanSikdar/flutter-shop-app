import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/data/product_data.dart';

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

  void addProduct(Product product) {
    Product newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);

    _items.insert(0, newProduct);
    notifyListeners();
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
}
