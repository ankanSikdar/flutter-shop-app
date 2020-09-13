import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/error_dialog.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshPage(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchProducts(fetchByUserId: true);
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(
            error: error.toString(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshPage(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('ERROR: ${snapshot.error.toString()}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<Products>(
                builder: (context, productsData, child) => RefreshIndicator(
                  onRefresh: () => _refreshPage(context),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            UserProductItem(
                              id: productsData.items[index].id,
                              title: productsData.items[index].title,
                              imageUrl: productsData.items[index].imageUrl,
                            ),
                            Divider(),
                          ],
                        );
                      },
                      itemCount: productsData.items.length,
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
