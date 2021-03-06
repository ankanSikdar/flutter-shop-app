import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(
              create: (BuildContext context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) {
              return Products();
            },
            update: (context, auth, previousProductsState) {
              return Products(
                  auth.token,
                  auth.userId,
                  previousProductsState.items == null
                      ? []
                      : previousProductsState.items);
            },
          ),
          ChangeNotifierProvider<Cart>(
              create: (BuildContext context) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) {
              return Orders();
            },
            update: (context, auth, previousOrdersState) {
              return Orders(
                auth.token,
                previousOrdersState.orders == null
                    ? []
                    : previousOrdersState.orders,
                auth.userId,
              );
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.orange,
              fontFamily: GoogleFonts.cabin().fontFamily,
              textTheme: TextTheme(
                headline6: TextStyle(
                  fontFamily: GoogleFonts.cabin().fontFamily,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.orange,
              ),
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.isAutoLogin(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SplashScreen();
                      }
                      return AuthScreen();
                    },
                  ),
            routes: {
              AuthScreen.routeName: (context) => AuthScreen(),
              ProductOverviewScreen.routeName: (context) =>
                  ProductOverviewScreen(),
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          ),
        ));
  }
}
