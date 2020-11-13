import 'package:FoodSight/providers/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/userRestaurants.dart';
import '../widgets/restaurant_item.dart';

class FavRestaurantsListView extends StatelessWidget {
  final String searchValue;

  FavRestaurantsListView(this.searchValue);

  @override
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<UserRestaurants>(context);
    final favRestaurantsIds = restaurantData.favRestaurants;

    if (searchValue == "null") {
      final restaurants = Provider.of<Restaurants>(context)
          .getFavRestaurantList(favRestaurantsIds);
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
      final restaurants = Provider.of<Restaurants>(context)
          .getFavListByNameSearch(favRestaurantsIds, searchValue);
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
