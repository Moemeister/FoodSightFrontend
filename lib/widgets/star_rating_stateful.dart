import 'package:FoodSight/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurants.dart';

import './star_rating.dart';

class StatefulStarRating extends StatelessWidget {
  final int rate;
  final bool isRestaurant;
  final Restaurant restaurant;

  StatefulStarRating({this.rate, this.isRestaurant, this.restaurant});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<Restaurants>(context, listen: false);
    if (isRestaurant) {
      int rating = rate;
      return StatefulBuilder(builder: (context, setState) {
        return StarRating(
          onChanged: (index) {
            setState(() {
              print("Voy a cambiar de valor RESTAURANTE");
              rating = index;
              restaurantProvider.setRating(restaurant, rating + .0);
            });
          },
          value: rating,
        );
      });
    } else {
      int rating = rate;
      return StatefulBuilder(builder: (context, setState) {
        return StarRating(
          onChanged: (index) {
            setState(() {
              print("Voy a cambiar de valor PRODUCTO maje");
              rating = index;
            });
          },
          value: rating,
        );
      });
    }
  }
}
