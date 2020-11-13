import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProducts with ChangeNotifier {
  final String authId;
  List<String> _productsIds;
  UserProducts(this.authId, this._productsIds);

  Future<void> fetchUserFavProducts() async {
    const url = 'https://foodsight-api.herokuapp.com/test/favoriteProducts';
    try {
      final response = await http.post(
        url,
        body: {
          "_id": authId,
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "_id": authId,
        },
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((key, value) {
        _productsIds.add(value);
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<String> get favProducts {
    return [..._productsIds];
  }

  void cleanList() {
    var distinctIds = [
      ...{..._productsIds}
    ];
    _productsIds.clear();
    _productsIds = distinctIds;
    print(_productsIds);
  }

  bool isPartOfFavProduct(String id) {
    if (_productsIds.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  void updateFavProduct(String id, bool flag) async {
    const addFavoriteURL =
        'https://foodsight-api.herokuapp.com/test/addFavoriteProduct';
    const removeFavoriteURL =
        'https://foodsight-api.herokuapp.com/test/removeFavoriteProduct';
    try {
      if (flag) {
        //Remover Favorito
        final response = await http.post(
          removeFavoriteURL,
          body: {
            "_productId": id,
          },
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "_id": authId,
          },
        );
        _productsIds.remove(id);
        print(response.body);
        notifyListeners();
      } else {
        //agregar a Favorito
        final response = await http.post(
          addFavoriteURL,
          body: {
            "productID": id,
          },
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "_id": authId,
          },
        );
        _productsIds.add(id);
        print(response.body);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
