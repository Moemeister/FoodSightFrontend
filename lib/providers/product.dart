import 'package:flutter/material.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      name: 'Pollo',
      description: 'guisado',
      price: 12.0,
      image:
          'https://live.mrf.io/statics/i/ps/www.cocinacaserayfacil.net/wp-content/uploads/2017/07/pollo-guisado-con-verduras-receta.jpg?width=1200&enable=upscale',
      rating: 4.3,
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: product.name,
      description: product.description,
      price: product.price,
      rating: product.rating,
      image: product.image,
    );
    _items.add(newProduct);
    notifyListeners();
  }
}
