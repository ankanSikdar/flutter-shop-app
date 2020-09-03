import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(
            Icons.favorite,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {},
        ),
        title: Container(
          width: 80,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.add_shopping_cart,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
