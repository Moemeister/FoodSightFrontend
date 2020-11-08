import 'package:flutter/material.dart';

import './star_rating.dart';

class StatefulStarRating extends StatelessWidget {
  final int rate;
  final bool isRestaurant;

  StatefulStarRating({this.rate, this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    if (isRestaurant) {
      int rating = rate;
      return StatefulBuilder(builder: (context, setState) {
        return StarRating(
          onChanged: (index) {
            setState(() {
              print("Voy a cambiar de valor RESTAURANTE maje");
              rating = index;
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
