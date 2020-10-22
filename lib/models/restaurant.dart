import 'package:flutter/material.dart';

enum PriceCategory {
  All,
  Affordable,
  Pricey,
  Luxurious,
}

class Restaurant with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final String password;
  final String photoUrl;
  final String location;
  final String description;
  final String phone;
  final String address;
  final String fbUrl;
  final String instaUrl;
  final double rating;
  final PriceCategory priceCategory;

  Restaurant(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.photoUrl,
      this.location,
      this.description,
      this.phone,
      this.address,
      this.fbUrl,
      this.instaUrl,
      this.rating,
      this.priceCategory});

  String get priceRange {
    switch (priceCategory) {
      case PriceCategory.Affordable:
        return '\$';
      case PriceCategory.Pricey:
        return '\$\$';
      case PriceCategory.Luxurious:
        return '\$\$\$';
      default:
        return 'Unknown';
    }
  }
}
