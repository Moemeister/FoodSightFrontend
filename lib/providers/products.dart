import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  // List<Product> _items = [
  //   Product(
  //       id: "p1",
  //       idRestaurant: "r1",
  //       name: "Ratatouille",
  //       description: "Exquisitas hortalizas guisadas",
  //       price: 5.00,
  //       imageUrl:
  //           "https://upload.wikimedia.org/wikipedia/commons/8/8a/Ratatouille02.jpg",
  //       rating: 3.0),
  //   Product(
  //       id: "p2",
  //       idRestaurant: "r2",
  //       name: "Chory",
  //       description: "Exquisito hot dog con repollo, salsas y chile",
  //       price: 1.10,
  //       imageUrl:
  //           "https://cdn-pro.elsalvador.com/wp-content/uploads/2018/01/Chory.jpg",
  //       rating: 5.0),
  //   Product(
  //     id: 'p3',
  //     idRestaurant: "r1",
  //     name: 'Pollo',
  //     description: 'guisado',
  //     price: 12.0,
  //     imageUrl:
  //         'https://live.mrf.io/statics/i/ps/www.cocinacaserayfacil.net/wp-content/uploads/2017/07/pollo-guisado-con-verduras-receta.jpg?width=1200&enable=upscale',
  //     rating: 4.3,
  //   ),
  // ];

  final String authId;
  List<Product> _items = [];

  Products(this.authId, this._items);

  Future<void> fetchProduct() async {
    final response = await http
        .get('https://foodsight-api.herokuapp.com/api/guestAllProducts');
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      bool flag = true;
      extractedData.forEach((key, value) {
        if (flag) {
          List insideVal = value as List;
          for (int i = 0; i < insideVal.length; i++) {
            _items.add(Product.fromJson(value[i]));
          }
          flag = false;
        }
      });

      notifyListeners();
    } else {
      throw Exception('Failed to load Products');
    }
  }

  List<Product> get items {
    print('SOY UN ID EXTRAIDO DE LA RESPUESTA DEL LOGIN $authId');
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> productsOfRestaurant(String resId) {
    return _items.where((element) => element.idRestaurant == resId).toList();
  }

  Future<void> addProduct(Product product) {
    const urlHeroku = 'https://foodsight-api.herokuapp.com/api/product/create';

    print(product.imageUrl.toString() + "putisima madre");
    return http
        .post(
      urlHeroku,
      headers: {
        "Content-Type": "multipart/form-data",
        "_id": "5f972850e5f83c001786715c",
      },
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'image': product.imageUrl,
        'rating': product.rating,
      }),
    )
        .then((response) {
      final newProduct = Product(
          //id: json.decode(response.body)['id'],
          idRestaurant: product.idRestaurant,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          rating: product.rating);

      _items.add(newProduct);
      notifyListeners();
    });
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
