import 'package:flutter/material.dart';
import '../widgets/restaurant_grid.dart';
import '../widgets/drawer.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FoodSight'),
      ),
      drawer: MainDrawer(),
      body: RestaurantGrid(),
    );
  }
}
