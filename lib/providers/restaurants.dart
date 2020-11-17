import 'package:FoodSight/helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../models/restaurant.dart';
import 'package:http_parser/http_parser.dart';

class Restaurants with ChangeNotifier {
  List<Restaurant> _items = [];
  static Restaurant _restaurant = new Restaurant();

  Future<void> fetchRestaurant() async {
    final response = await http
        .get('https://foodsight-api.herokuapp.com/api/guestAllRestaurants');
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      bool flag = true;
      extractedData.forEach((key, value) {
        if (flag) {
          List insideVal = value as List;
          for (int i = 0; i < insideVal.length; i++) {
            _items.add(Restaurant.fromJson(value[i]));
          }
          flag = false;
        }
      });
      notifyListeners();
    } else {
      throw Exception('Failed to load Restaurant');
    }
  }

  List<Restaurant> get items {
    return [..._items];
  }

  List<Restaurant> getList(PriceCategory selectedCategory) {
    return selectedCategory == PriceCategory.All
        ? [..._items]
        : _items
            .where((element) => element.priceCategory == selectedCategory)
            .toList();
  }

  List<Restaurant> getListByNameSearch(String value) {
    return _items
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  List<Restaurant> getFavRestaurantList(List<String> ids) {
    return _items.where((element) => ids.contains(element.id)).toList();
  }

  List<Restaurant> getFavListByNameSearch(List<String> ids, String value) {
    return _items
        .where((element) =>
            ids.contains(element.id) &&
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  Restaurant findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addRestaurant(Restaurant restaurant, File image,
      RestaurantLocation pickedLocation) async {
    restaurant.location =
        '${pickedLocation.latitude},${pickedLocation.longitude}';
    const url = 'https://foodsight-api.herokuapp.com/api/auth/signup';
    Dio dio = new Dio();
    print("********** RUTA DE FOTO: " + image.toString());
    final address = await LocationHelper.getResAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    try {
      String filename = image.path.split('/').last;
      FormData formData = new FormData.fromMap({
        'name': restaurant.name,
        'email': restaurant.email,
        'password': restaurant.password,
        'description': restaurant.description,
        'phone': restaurant.phone,
        'rating': 0,
        'address': address,
        'location': restaurant.location,
        'facebook': restaurant.fbUrl,
        'instagram': restaurant.instaUrl,
        'photo': await MultipartFile.fromFile(image.path,
            filename: filename, contentType: MediaType('image', 'jpg')),
      });
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            //"Content-Type": "multipart/form-data",
            //"_id": '$authId',
            //"_id": "5f972850e5f83c001786715c",
          },
        ),
      );

      print('buenas  tardes' + response.data['photo'].toString());
      final newRestaurant = Restaurant(
        id: response.data['id'],
        address: address,
        description: restaurant.description,
        email: restaurant.email,
        fbUrl: restaurant.fbUrl,
        rating: restaurant.rating,
        instaUrl: restaurant.instaUrl,
        location: restaurant.location,
        name: restaurant.name,
        password: restaurant.password,
        phone: restaurant.phone,
        photoUrl: response.data['photo'].toString(),
      );
      _items.add(newRestaurant);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateRestaurant(String id, Restaurant newRestaurant, File image,
      RestaurantLocation pickedLocation) async {
    newRestaurant.location =
        '${pickedLocation.latitude},${pickedLocation.longitude}';
    final address = await LocationHelper.getResAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final resIndex = _items.indexWhere((res) => res.id == id);
    const url = 'https://foodsight-api.herokuapp.com/api/restaurant/update';
    Dio dio = new Dio();
    String filename = 'test';
    if (resIndex >= 0) {
      try {
        if (image != null) {
          filename = image.path.split('/').last;
        }
        FormData formData = new FormData.fromMap({
          '_id': id,
          'name': newRestaurant.name,
          'email': newRestaurant.email,
          //'password': newRestaurant.password,
          'description': newRestaurant.description,
          'phone': newRestaurant.phone,
          'location': '${pickedLocation.latitude},${pickedLocation.longitude}',
          'address': address,
          'rating': newRestaurant.rating,
          'facebook': newRestaurant.fbUrl,
          'instagram': newRestaurant.instaUrl,
          'photo': image == null
              ? newRestaurant.photoUrl
              : await MultipartFile.fromFile(image.path,
                  filename: filename, contentType: MediaType('image', 'jpg')),
        });
        Response response = await dio.put(
          url,
          data: formData,
          options: Options(
            headers: {
              //"Content-Type": "multipart/form-data",
              "_id": id,
            },
          ),
        );

        //print(response.body);
        newRestaurant.photoUrl = response.data['photo'].toString();
        newRestaurant.address = address;
        _items[resIndex] = newRestaurant;
        notifyListeners();
      } catch (error) {
        print(error);
      }
    }
  }

  void setRating(Restaurant restaurant, double rate) {
    print("Antes de intentar asignar el valor del rating");
    _restaurant.rating = rate;
    print("Restaurant id: ${restaurant.id} Rate $rate");
  }

  void rateRestaurant(Restaurant restaurant) async {
    const url = 'https://foodsight-api.herokuapp.com/test/rateRestaurant';

    print("_RESTAURANT: ${_restaurant.rating}");

    http.Response response = await http.patch(url, body: {
      "_id": restaurant.id.toString(),
      "rate": _restaurant.rating.toString(),
    });

    _restaurant.rating = null;

    int statusCode = response.statusCode;

    String body = response.body;
    print("Status Code: $statusCode. Body: $body");
  }
}
