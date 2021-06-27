import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    final productTitle = product.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(productTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${product.price} KM',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              softWrap: true,
            ),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              product.description,
            )
          ],
        ),
      ),
    );
  }
}
