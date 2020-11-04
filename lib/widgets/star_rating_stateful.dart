import 'package:flutter/material.dart';

import './star_rating.dart';

class StatefulStarRating extends StatelessWidget {
  final int rate;

  StatefulStarRating(this.rate);

  @override
  Widget build(BuildContext context) {
    int rating = rate;
    return StatefulBuilder(
      builder: (context, setState) {
        return StarRating(
          onChanged: (index) {
            setState(() {
              rating = index;
            });
          },
          value: rating,
        );
      },
    );
  }
}
