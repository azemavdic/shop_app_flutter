import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Center(
                child: Text(
              'Meni',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Pocetna'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Narudzba'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
