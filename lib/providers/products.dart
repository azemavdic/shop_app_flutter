import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  Products(this.authToken, this._items, this.userId);

  final String authToken;
  final String userId;

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

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId' : '';
    var url = Uri.parse(
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString"');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'].toString(),
            imageUrl: prodData['imageUrl'].toString(),
            description: prodData['description'].toString(),
            // ignore: avoid_bool_literals_in_conditional_expressions
            isFavorite: favoriteData == null
                ? false
                : favoriteData[prodId] as bool ?? false,
            price: double.parse(prodData['price'].toString()),
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
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'userId': userId,
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
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
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
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');
    try {
      await http.delete(url);
    } catch (e) {
      rethrow;
    }
    _items.removeWhere((prod) => prod.id == productId);
    notifyListeners();
  }
}
