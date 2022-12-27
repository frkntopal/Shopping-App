import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // _ordersFuture,_obtainOrdersFuture ve altındaki initstate yaklaşımı, uygulama tekrar çalıştığında fetchAndSetOrders'da çalışır,
  // bu olduğunda ise yeni siparişler almak istemiyorsak bu yaklaşımı kullanmak oldukça mantıklıdır. Gereksiz http isteklerinin gönderilmemesini sağlar.
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x22844BCA),
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              //Do error hanglind stuff
              return const Center(
                child: Text('An error occured'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
