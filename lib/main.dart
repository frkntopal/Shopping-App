import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/splash_screen.dart';

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
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('', "", []),
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ), // Burada giriş yaptıktan sonra ürünlerimizin gelmesini sağladık
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', "", []),
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
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
                home: auth.isAuth
                    ? const ProductOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen(),
                      ),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => const CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductsScreen.routeName: (ctx) =>
                      const UserProductsScreen(),
                  EditProductScreen.routeName: (ctx) => EditProductScreen(),
                },
              )),
        ));
  }
}
