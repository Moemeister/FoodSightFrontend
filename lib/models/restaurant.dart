import 'package:flutter/material.dart';

enum PriceCategory {
  All,
  Affordable,
  Pricey,
  Luxurious,
}

class Restaurant with ChangeNotifier {
  String id;
  String name;
  String email;
  String password;
  String photoUrl;
  String location;
  String description;
  String phone;
  String address;
  String fbUrl;
  String instaUrl;
  double rating;
  PriceCategory priceCategory = PriceCategory.Affordable;

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
      this.priceCategory = PriceCategory.Affordable});

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['hashedPassword'];
    description = json['description'];
    phone = json['phone'];
    rating = json['rating'] + .0;
    photoUrl = json['photo'];
    fbUrl = json['facebook'];
    instaUrl = json['instagram'];
  }

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
