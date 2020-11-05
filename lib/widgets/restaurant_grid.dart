import 'package:FoodSight/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurants.dart';
import '../widgets/restaurant_item.dart';

class RestaurantListView extends StatelessWidget {
  final PriceCategory showRestaurantByPriceCategory;
  final String searchValue;
  RestaurantListView(this.showRestaurantByPriceCategory, this.searchValue);
  @override
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<Restaurants>(context);
    if (searchValue == "null") {
      final restaurants = restaurantData.getList(showRestaurantByPriceCategory);
      return Center(
        child: ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
            value: restaurants[index],
            child: RestaurantItem(),
          ),
        ),
      );
    } else {
      final restaurants = restaurantData.getListByNameSearch(searchValue);
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
}
