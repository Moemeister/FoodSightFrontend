import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../models/restaurant.dart';

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

  Future<void> addRestaurant(Restaurant restaurant) async {
    const url = 'https://foodsight-api.herokuapp.com/api/auth/signup';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': restaurant.name,
          'email': restaurant.email,
          'password': restaurant.password,
          'description': restaurant.description,
          'phone': restaurant.phone,
          'rating': 5,
          'photo': restaurant.photoUrl,
          'facebook': restaurant.fbUrl,
          'instagram': restaurant.instaUrl
        }),
      );
      print(response.body);
      final newRestaurant = Restaurant(
        id: json.decode(response.body)['id'],
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
        photoUrl: restaurant.photoUrl,
      );
      _items.add(newRestaurant);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateRestaurant(String id, Restaurant newRestaurant) async {
    final resIndex = _items.indexWhere((res) => res.id == id);

    if (resIndex >= 0) {
      const url = 'https://foodsight-api.herokuapp.com/api/restaurant/update';
      try {
        final response = await http.put(
          url,
          headers: {"Content-Type": "application/json", "_id": id},
          body: json.encode({
            '_id': id,
            'name': newRestaurant.name,
            'email': newRestaurant.email,
            'password': newRestaurant.password,
            'description': newRestaurant.description,
            'phone': newRestaurant.phone,
            'rating': newRestaurant.rating,
            'photo': newRestaurant.photoUrl,
            'facebook': newRestaurant.fbUrl,
            'instagram': newRestaurant.instaUrl
          }),
        );
        //print(response.body);
        _items[resIndex] = newRestaurant;
        notifyListeners();
      } catch (error) {
        print(error);
      }
    }
  }
}
