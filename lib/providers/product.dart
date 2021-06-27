import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.price,
    this.isFavorite = false,
  });

  Future<void> toogleFavorite() async {
    final url = Uri.parse(
        'https://flutter-shop-app-cfef3-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    await http.patch(url, body: json.encode({'isFavorite': !isFavorite}));
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
