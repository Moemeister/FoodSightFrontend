import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _id;
  String email;
  String password;

  // bool get isAuth {
  //   return _id != null;
  // }

  String get logId {
    return _id;
  }

  Future<void> signInRes(String email, String password) async {
    const url = 'https://foodsight-api.herokuapp.com/api/auth/signin';

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email, 'password': password}),
      );

      print('SOY UN RESTAURANTE');

      final responseData = json.decode(response.body);
      _id = responseData.toString();
      notifyListeners();
      if (responseData.toString().contains('error')) {
        print('SOY UN RESTAURANTE aqui error?');
        throw responseData['error'];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> signInUsr(String email, String password) async {
    const url = 'https://foodsight-api.herokuapp.com/test/authU/signin';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'identifier': email, 'password': password}),
      );

      final responseData = json.decode(response.body);
      if (responseData.toString().contains('error')) {
        throw responseData['error'];
      }
      _id = responseData.toString();

      print('SOY UN USUARIO');
      print(json.decode(response.body));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
