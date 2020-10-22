import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import '../widgets/restaurant_grid.dart';
import '../widgets/drawer.dart';

import '../models/restaurant.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
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
        searchBar.getSearchAction(context),
      ],
    );
  }

  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }

  _RestaurantsScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  PriceCategory _selectedPriceCategory = PriceCategory.All;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      drawer: MainDrawer(),
      body: RestaurantListView(_selectedPriceCategory),
    );
  }
}
