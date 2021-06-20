import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.productId,
  });

  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        color: Colors.red,
      ),
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  child: Text(
                    '$price KM',
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('UKUPNO: ${(price * quantity)} KM'),
            trailing: Text('Kolicina: ${quantity}x'),
          ),
        ),
      ),
    );
  }
}
