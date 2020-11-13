import 'package:flutter/material.dart';

import '../widgets/fav_restaurants_listview.dart';
import '../widgets/drawer.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class FavRestaurantsScreen extends StatefulWidget {
  static final String routeName = "/fav-restaurant";
  @override
  _FavRestaurantsScreenState createState() => _FavRestaurantsScreenState();
}

class _FavRestaurantsScreenState extends State<FavRestaurantsScreen> {
  SearchBar searchBar;

  var _searchValue = "null";

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text("Showing Favorite Restaurants"),
      actions: [
        searchBar.getSearchAction(context),
      ],
    );
  }

  void valueChanged(String value) {
    setState(() {
      _searchValue = value;
    });
  }

  _FavRestaurantsScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: valueChanged,
        onSubmitted: (_) {
          setState(() {
            _searchValue = "null";
          });
        },
        onCleared: () {
          setState(() {
            _searchValue = "null";
          });
          print("Search Bar cleared");
        },
        onClosed: () {
          setState(() {
            _searchValue = "null";
          });
          print("Search Bar closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      //drawer: MainDrawer(),
      body: FavRestaurantsListView(_searchValue),
    );
  }
}
