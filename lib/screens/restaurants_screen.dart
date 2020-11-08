import '../providers/userRestaurants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import '../widgets/restaurant_grid.dart';
import '../widgets/drawer.dart';

import '../models/restaurant.dart';
import '../models/product.dart';
import '../providers/restaurants.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class RestaurantsScreen extends StatefulWidget {
  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _isLoading = false;
  var _searchValue = "null";

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

  void valueChanged(String value) {
    setState(() {
      _searchValue = value;
    });
  }

  _RestaurantsScreenState() {
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

  PriceCategory _selectedPriceCategory = PriceCategory.All;

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (Provider.of<Restaurants>(context).items.isEmpty ||
          Provider.of<Products>(context).items.isEmpty) {
        setState(() {
          _isLoading = true;
        });
        Provider.of<Restaurants>(context, listen: false)
            .fetchRestaurant()
            .then((_) {
          Provider.of<Products>(context, listen: false)
              .fetchProduct()
              .then((_) {
            //Dynamic calculation of rating, based on products of the restaurants.
            print("Setting Price Categories 1");
            List<Restaurant> restaurants;
            restaurants =
                Provider.of<Restaurants>(context, listen: false).items;
            List<Product> products;
            restaurants.forEach((element) {
              products = Provider.of<Products>(context, listen: false)
                  .productsOfRestaurant(element.id);
              var acum = 0.0;
              int nitems = products.length;
              for (int i = 0; i < products.length; i++) {
                acum += products[i].price;
              }

              double category;
              if (nitems == 0) {
                category = 0.0;
              } else {
                category = acum / nitems;
              }
              if (category >= 0.0 && category <= 5.0) {
                element.priceCategory = PriceCategory.Affordable;
              } else if (category >= 5.1 && category <= 10.0) {
                element.priceCategory = PriceCategory.Pricey;
              } else {
                element.priceCategory = PriceCategory.Luxurious;
              }
            });
          }).then((_) {
            Provider.of<UserRestaurants>(context, listen: false)
                .fetchUserFavRestaurants()
                .then((_) => {
                      setState(() {
                        _isLoading = false;
                      })
                    });
          });
        });
      } else {
        //Dynamic calculation of rating, based on products of the restaurants.
        print("Setting Price Categories 2");
        List<Restaurant> restaurants;
        restaurants = Provider.of<Restaurants>(context, listen: false).items;
        List<Product> products;
        restaurants.forEach((element) {
          products = Provider.of<Products>(context, listen: false)
              .productsOfRestaurant(element.id);
          var acum = 0.0;
          int nitems = products.length;
          for (int i = 0; i < products.length; i++) {
            acum += products[i].price;
          }

          double category;
          if (nitems == 0) {
            category = 0.0;
          } else {
            category = acum / nitems;
          }
          if (category >= 0.0 && category <= 5.0) {
            element.priceCategory = PriceCategory.Affordable;
          } else if (category >= 5.1 && category <= 10.0) {
            element.priceCategory = PriceCategory.Pricey;
          } else {
            element.priceCategory = PriceCategory.Luxurious;
          }
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RestaurantListView(_selectedPriceCategory, _searchValue),
    );
  }
}
