import 'package:FoodSight/widgets/fav_products_listview.dart';
import 'package:flutter/material.dart';

import '../widgets/fav_restaurants_listview.dart';
import '../widgets/drawer.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class FavProductsScreen extends StatefulWidget {
  static final String routeName = "/fav-product";
  @override
  _FavProductsScreenState createState() => _FavProductsScreenState();
}

class _FavProductsScreenState extends State<FavProductsScreen> {
  SearchBar searchBar;

  var _searchValue = "null";

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text("Showing Favorite Products"),
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

  _FavProductsScreenState() {
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
      body: FavProductsListView(_searchValue),
    );
  }
}
