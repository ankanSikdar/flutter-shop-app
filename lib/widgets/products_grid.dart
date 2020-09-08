import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool onlyFavorites;

  ProductsGrid({this.onlyFavorites = false});

  @override
  Widget build(BuildContext context) {
    final _productsData = Provider.of<Products>(context);
    final List<Product> _products =
        onlyFavorites ? _productsData.favoriteItems : _productsData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: _products[index],
          child: ProductItem(
              // id: _products[index].id,
              // title: _products[index].title,
              // imageUrl: _products[index].imageUrl,
              ),
        );
      },
      itemCount: _products.length,
      padding: EdgeInsets.all(20),
    );
  }
}
