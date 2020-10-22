import 'package:flutter/material.dart';

import '../widgets/restaurant_grid.dart';
import '../widgets/drawer.dart';

import '../models/restaurant.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  PriceCategory _selectedPriceCategory = PriceCategory.All;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FoodSight'),
        actions: [
          PopupMenuButton(
            tooltip: "Filter for avg product price",
            onSelected: (selectedValue) {
              setState(() {
                _selectedPriceCategory = selectedValue;
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Text('Show All'),
                value: PriceCategory.All,
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                child: Text('Affordable'),
                value: PriceCategory.Affordable,
              ),
              PopupMenuItem(
                child: Text('Pricey'),
                value: PriceCategory.Pricey,
              ),
              PopupMenuItem(
                child: Text('Luxurious'),
                value: PriceCategory.Luxurious,
              ),
            ],
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: RestaurantListView(_selectedPriceCategory),
    );
  }
}
