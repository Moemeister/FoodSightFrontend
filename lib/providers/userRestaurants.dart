import 'package:flutter/cupertino.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRestaurants with ChangeNotifier {
  final String authId;
  List<String> _restaurantsId = [];
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

  bool isPartOfFavRest(String id) {
    if (_restaurantsId.contains(id)) {
      return true;
    } else {
      return false;
    }
  }
}
