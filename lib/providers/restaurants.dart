import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../models/restaurant.dart';
import 'package:http_parser/http_parser.dart';

class Restaurants with ChangeNotifier {
  // List<Restaurant> _items = [
  //   Restaurant(
  //     id: 'r1',
  //     name: 'Hipster Restaurant',
  //     email: 'hipsrestaurant@gmail.com',
  //     address: 'En el ranchito',
  //     description: 'La ensalada cuenta chistes muy graciosos',
  //     location: 'Por alla',
  //     password: '1234a',
  //     phone: '22577777',
  //     //priceCategory: PriceCategory.Pricey,
  //     rating: 3.0,
  //     photoUrl:
  //         'https://images-ext-1.discordapp.net/external/j66WmQSfDUAR1cAbnkrWrUL0hhX9UjUY4NCWbYrYuhg/%3Fixlib%3Drb-1.2.1%26ixid%3DeyJhcHBfaWQiOjEyMDd9%26auto%3Dformat%26fit%3Dcrop%26w%3D500%26q%3D60/https/images.unsplash.com/photo-1533777857889-4be7c70b33f7',
  //     fbUrl: 'https://www.facebook.com/PizzaHut.SV',
  //     instaUrl: 'https://www.youtube.com/watch?v=fC7oUOUEEi4',
  //   ),
  //   Restaurant(
  //     id: 'r2',
  //     name: 'Chorys',
  //     email: 'choripanes@gmail.com',
  //     address: 'Por todos lados',
  //     description: 'Ricos y Baratos',
  //     location: 'Por alla',
  //     password: '1234a',
  //     phone: '22577777',
  //     //priceCategory: PriceCategory.Affordable,
  //     rating: 5.0,
  //     photoUrl:
  //         'https://images-ext-1.discordapp.net/external/Szy_YZPb6vFgJ5Wcqv3QXqeZqW16XVd2LeaMZml7j8g/https/elsalvadorgram.com/wp-content/uploads/2020/06/Chory-A-domicilio.jpg?width=747&height=560',
  //     fbUrl: 'https://www.facebook.com/PizzaHut.SV',
  //     instaUrl: 'https://www.youtube.com/watch?v=fC7oUOUEEi4',
  //   ),
  // ];

  List<Restaurant> _items = [];
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

  Restaurant findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addRestaurant(Restaurant restaurant, File image) async {
    const url = 'https://foodsight-api.herokuapp.com/api/auth/signup';
    Dio dio = new Dio();
    print("********** RUTA DE FOTO: " + image.toString());
    try {
      String filename = image.path.split('/').last;
      FormData formData = new FormData.fromMap({
        'name': restaurant.name,
        'email': restaurant.email,
        'password': restaurant.password,
        'description': restaurant.description,
        'phone': restaurant.phone,
        'rating': 5,
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
        address: restaurant.address,
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

  Future<void> updateRestaurant(
      String id, Restaurant newRestaurant, File image) async {
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
          'password': newRestaurant.password,
          'description': newRestaurant.description,
          'phone': newRestaurant.phone,
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
        _items[resIndex] = newRestaurant;
        notifyListeners();
      } catch (error) {
        print(error);
      }
    }
  }
}
