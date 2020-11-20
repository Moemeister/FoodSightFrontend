import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  String id;
  String idRestaurant;
  String name;
  String description;
  double price;
  String imageUrl;
  double rating;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.rating,
    this.idRestaurant,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'] + .0;
    imageUrl = json['image'];
    idRestaurant = json['restaurant'];
  }
}
