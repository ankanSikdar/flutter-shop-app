import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapShot.hasError) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else if (dataSnapShot.data == null) {
              return Center(child: Text('No Orders Placed Yet!'));
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, child) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return OrderItem(
                        orderItem: orderData.orders[index],
                      );
                    },
                    itemCount: orderData.orders.length,
                  );
                },
              );
            }
          },
        ));
  }
}

// final orderData = Provider.of<Orders>(context);
