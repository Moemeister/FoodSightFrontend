import 'package:flutter/cupertino.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserLists with ChangeNotifier {
  final String authId;
  UserLists(this.authId);

  List<String> _restaurantsId = [];
  List<String> _productsId = [];

  Future<void> fetchUserFavRestaurants() async {
    const url = 'https://foodsight-api.herokuapp.com/test/favoriteProducts';

    try {
      final response = await http.post(
        url,
        body: {
          "_id": "5f9381edd4f0ce29b861682f",
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "_id": "5f9381edd4f0ce29b861682f",
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
}
