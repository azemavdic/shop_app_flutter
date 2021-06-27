import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'].toString(),
            imageUrl: prodData['imageUrl'].toString(),
            description: prodData['description'].toString(),
            price: double.parse(prodData['price'].toString()),
            isFavorite: prodData['isFavorite'] as bool,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'].toString(),
        title: product.title,
        imageUrl: product.imageUrl,
        description: product.description,
        price: product.price,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url = Uri.parse(
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    try {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json');
    try {
      await http.delete(url);
    } catch (e) {
      rethrow;
    }
    _items.removeWhere((prod) => prod.id == productId);
    notifyListeners();
  }
}
