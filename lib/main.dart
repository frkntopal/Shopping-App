import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/edit_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(const MyHomePage());

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Products(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Orders(),
          )
        ],
        child: Consumer<Auth>(
          builder: ((ctx, auth, _) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Shopping',
                theme: ThemeData(
                  primaryColor: Color.fromRGBO(132, 75, 202, 0.133),
                  fontFamily: 'Lato',
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: Colors.deepOrange),
                ),
                home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                  EditProductScreen.routeName: (ctx) => EditProductScreen(),
                },
              )),
        ));
  }
}
