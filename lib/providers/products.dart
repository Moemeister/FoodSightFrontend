import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
    //print('SOY UN ID EXTRAIDO DE LA RESPUESTA DEL LOGIN $authId');
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> productsOfRestaurant(String resId) {
    return _items.where((element) => element.idRestaurant == resId).toList();
  }

  Future<void> addProduct(Product product, File image) async {
    const urlHeroku = 'https://foodsight-api.herokuapp.com/api/product/create';
    Dio dio = new Dio();
    print("********** RUTA DE FOTO: " + image.toString());

    try {
      String filename = image.path.split('/').last;
      FormData formData = new FormData.fromMap({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'rating': product.rating,
        'image': await MultipartFile.fromFile(image.path,
            filename: filename, contentType: MediaType('image', 'jpg')),
      });
      Response response = await dio.post(
        urlHeroku,
        data: formData,
        options: Options(
          headers: {
            //"Content-Type": "multipart/form-data",
            "_id": '$authId',
            //"_id": "5f972850e5f83c001786715c",
          },
        ),
      );
      print('SOY LA RESPUESTA DE LA API' + response.data['photo']);
      print('HOLI SOY EL ID DEL PRODUCTO NUEVO' + response.data['id']);
      //LOCAL
      print('ANTES DE AGREGAR NUEVO ' + _items.length.toString());
      final newRestaurant = Product(
        id: response.data['id'],
        idRestaurant: '$authId',
        name: product.name,
        description: product.description,
        price: product.price,
        rating: product.rating,
        imageUrl: response.data['photo'].toString(),
      );
      _items.add(newRestaurant);
      print('DESPUES DE AGREGAR NUEVO ' + _items.length.toString());
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProduct(String id, Product newProduct, File image) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    print(prodIndex);
    const urlHeroku = 'https://foodsight-api.herokuapp.com/api/product/update';
    Dio dio = new Dio();
    print("********** RUTA DE FOTO: " + image.toString());
    String filename = 'test';
    print("FOTOOOOO" + newProduct.imageUrl);
    if (prodIndex >= 0) {
      try {
        if (image != null) {
          filename = image.path.split('/').last;
        }
        FormData formData = new FormData.fromMap({
          '_id': id,
          'name': newProduct.name,
          'description': newProduct.description,
          'price': newProduct.price,
          'rating': newProduct.rating,
          'image': image == null
              ? newProduct.imageUrl
              : await MultipartFile.fromFile(image.path,
                  filename: filename, contentType: MediaType('image', 'jpg')),
        });
        Response response = await dio.put(
          urlHeroku,
          data: formData,
          options: Options(
            headers: {
              //"Content-Type": "multipart/form-data",
              "_id": "$authId",
            },
          ),
        );
        newProduct.imageUrl = response.data['photo'].toString();
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    const url = "https://foodsight-api.herokuapp.com/api/product/";
    //const url = "http://192.168.1.6:3000/api/product/";
    final prodIndex = _items.indexWhere((element) => element.id == id);
    Dio dio = new Dio();

    try {
      Response response = await dio.delete(
        url,
        data: {'_id': id},
        options: Options(
          headers: {
            // "Content-Type": "application/x-www-form-urlencoded",
            //HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
            "_id": "$authId",
          },
        ),
      );

      _items.removeAt(prodIndex);
      notifyListeners();
    } on DioError catch (e) {
      print(e.response.data);
    }
  }

  List<Product> getListByNameSearch(String id, String value) {
    return _items
        .where((element) =>
            element.idRestaurant == id &&
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }
}
