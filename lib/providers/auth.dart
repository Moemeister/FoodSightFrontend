import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum TypeLogin { IsRestaurant, IsUser, IsGeneral }

class Auth with ChangeNotifier {
  String _id;
  TypeLogin whatIs = TypeLogin.IsGeneral;
  String email;
  String password;

  // bool get isAuth {
  //   return _id != null;
  // }

  String get logId {
    print('ME MANDARON A LLAMAR WEEE ' + _id.toString());
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

      final responseData = json.decode(response.body);
      _id = responseData.toString();
      whatIs = TypeLogin.IsRestaurant;
      print('SOY UN RESTAURANTE ' + loginType);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(
          {'id': _id, 'loginType': TypeLogin.IsRestaurant.toString()});
      prefs.setString('userLogged', userData);
      if (responseData.toString().contains('error')) {
        //print('SOY UN RESTAURANTE aqui error?');
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
      whatIs = TypeLogin.IsUser;
      print('SOY UN USUARIO' + _id);
      print(json.decode(response.body));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData =
          jsonEncode({'id': _id, 'loginType': TypeLogin.IsUser.toString()});
      prefs.setString('userLogged', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUpUsr(String email, String username, String password) async {
    const url = 'https://foodsight-api.herokuapp.com/test/authU/signup';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            {'email': email, 'username': username, 'password': password}),
      );

      print(json.encode(
          {'email': email, 'username': username, 'password': password}));

      if (response.body.isNotEmpty &&
          response.body.toString().contains('error')) {
        final responseData = json.decode(response.body);
        throw responseData['error'];
      }
      //_id = responseData;

      //print('SOY UN NUEVO USUARIO' + json.decode(response.body));
      //print(json.decode(response.body));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    _id = null;
    whatIs = TypeLogin.IsGeneral;
    notifyListeners();
    print('LOOK YOU LOGGED OUT ' + loginType);
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userLogged');
  }

  String get loginType {
    switch (whatIs) {
      case TypeLogin.IsGeneral:
        return 'general';
        break;
      case TypeLogin.IsRestaurant:
        return 'restaurante';
        break;
      case TypeLogin.IsUser:
        return 'usuario';
        break;
      default:
        return 'general';
        break;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userLogged')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userLogged')) as Map<String, Object>;
    _id = extractedUserData['id'];
    whatIs = extractedUserData['loginType'];
    notifyListeners();
    return true;
  }
}
