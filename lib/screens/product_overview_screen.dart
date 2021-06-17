import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  All,
  Favorite,
}

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pocetna'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions value) {
              if (value == FilterOptions.Favorite) {
                productData.showFavoritesOnly();
              } else {
                productData.showAll();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Favoriti'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Svi'),
                value: FilterOptions.All,
              ),
            ],
          )
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
