import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _productsData = Provider.of<Products>(context);
    final List<Product> _products = _productsData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
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
