import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import '../providers/products.dart';
import '../providers/restaurants.dart';
import '../widgets/product_item.dart';
import '../screens/restaurant_info.dart';

class RestaurantDetail extends StatefulWidget {
  static final routeName = "/restaurant-detail";
  final String id;

  RestaurantDetail({this.id});

  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  SearchBar searchBar;
  var _searchValue = "null";
  void tappedInfo(BuildContext ctx, id) {
    Navigator.of(ctx).pushNamed(RestaurantInformation.routeName, arguments: id);
  }

  AppBar buildAppBar(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments as String;
    final restaurant =
        Provider.of<Restaurants>(context, listen: false).findById(id);
    return new AppBar(
      title: Text('Seeing ${restaurant.name}'),
      actions: [
        searchBar.getSearchAction(context),
        InkWell(
          onTap: () => tappedInfo(context, restaurant.id),
          child: Icon(Icons.info),
        ),
      ],
    );
  }

  void valueChanged(String value) {
    setState(() {
      _searchValue = value;
    });
  }

  _RestaurantDetailState() {
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
    final String id = ModalRoute.of(context).settings.arguments as String;
    final productsData = Provider.of<Products>(context);
    if (_searchValue == "null") {
      final products = productsData.productsOfRestaurant(id);
      return Scaffold(
        appBar: searchBar.build(context),
        body: Center(
          child: ListView.builder(
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ),
            itemCount: products.length,
          ),
        ),
      );
    } else {
      final products = productsData.getListByNameSearch(id,_searchValue);
      return Scaffold(
        appBar: searchBar.build(context),
        body: Center(
          child: ListView.builder(
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ),
            itemCount: products.length,
          ),
        ),
      );
    }
  }
}
