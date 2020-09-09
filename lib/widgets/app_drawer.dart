import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Ankan!'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ProductOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('Your Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}