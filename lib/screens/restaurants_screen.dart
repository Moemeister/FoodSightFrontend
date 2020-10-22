import 'package:flutter/material.dart';
import '../widgets/restaurant_grid.dart';
import '../widgets/drawer.dart';

class RestaurantsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FoodSight'),
      ),
      drawer: MainDrawer(),
      body: RestaurantListView(),
    );
  }
}
