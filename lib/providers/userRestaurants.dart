import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRestaurants with ChangeNotifier {
  final String authId;
  List<String> _restaurantsId;
  UserRestaurants(this.authId, this._restaurantsId);

  Future<void> fetchUserFavRestaurants() async {
    const url = 'https://foodsight-api.herokuapp.com/test/favoriteRestaurant';
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
        _restaurantsId.add(value);
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<String> get favRestaurants {
    return [..._restaurantsId];
  }

  void cleanList() {
    var distinctIds = [
      ...{..._restaurantsId}
    ];
    _restaurantsId.clear();
    _restaurantsId = distinctIds;
    print(_restaurantsId);
  }

  bool isPartOfFavRest(String id) {
    if (_restaurantsId.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  void updateFavRest(String id, bool flag) async {
    const addFavoriteURL =
        'https://foodsight-api.herokuapp.com/test/addFavoriteRestaurant';
    const removeFavoriteURL =
        'https://foodsight-api.herokuapp.com/test/removeFavoriteRestaurant';
    try {
      if (flag) {
        //Remover Favorito
        final response = await http.post(
          removeFavoriteURL,
          body: {
            "_restaurantId": id,
          },
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "_id": authId,
          },
        );
        _restaurantsId.remove(id);
        print(response.body);
        notifyListeners();
      } else {
        //agregar a Favorito
        final response = await http.post(
          addFavoriteURL,
          body: {
            "restaurantID": id,
          },
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "_id": authId,
          },
        );
        _restaurantsId.add(id);
        print(response.body);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
