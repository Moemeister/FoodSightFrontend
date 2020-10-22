import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final double rating;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.rating,
  });
}
