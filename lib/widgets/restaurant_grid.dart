import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurants.dart';
import '../widgets/restaurant_item.dart';

class RestaurantListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<Restaurants>(context);
    final restaurants = restaurantData.items;

    return Center(
      child: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: restaurants[index],
          child: RestaurantItem(),
        ),
      ),
    );
  }
}
