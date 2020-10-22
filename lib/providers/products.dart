import 'package:flutter/material.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: "p1",
        idRestaurant: "r1",
        name: "Ratatouille",
        description: "Exquisitas hortalizas guisadas",
        price: 5.00,
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/8/8a/Ratatouille02.jpg",
        rating: 3.0),
    Product(
        id: "p2",
        idRestaurant: "r2",
        name: "Chory",
        description: "Exquisito hot dog con repollo, salsas y chile",
        price: 1.10,
        imageUrl:
            "https://cdn-pro.elsalvador.com/wp-content/uploads/2018/01/Chory.jpg",
        rating: 5.0),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
        id: product.id,
        idRestaurant: product.idRestaurant,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        rating: product.rating);

    _items.add(newProduct);
    notifyListeners();
  }
}
