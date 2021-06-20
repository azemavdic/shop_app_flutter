import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';
import 'package:shop_app/providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Narudzbe'),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (context, index) {
          return OrderItem(
            order: ordersData.orders[index],
          );
        },
      ),
    );
  }
}
