import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String idRestaurant;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.rating,
    this.idRestaurant,
  });
}
