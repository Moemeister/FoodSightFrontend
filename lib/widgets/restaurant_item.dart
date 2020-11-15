import 'package:FoodSight/widgets/star_rate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant.dart';
import '../screens/restaurant_detail.dart';
import '../screens/restaurant_form_screen.dart';
import '../providers/userRestaurants.dart';
import '../providers/restaurants.dart';
import '../providers/auth.dart';
import '../widgets/star_rating.dart';

class RestaurantItem extends StatelessWidget {
  void selectedRestaurant(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(RestaurantDetail.routeName, arguments: id);
  }

  void _addToFavorite(String id, bool flag, BuildContext ctx) {
    Provider.of<UserRestaurants>(ctx, listen: false).updateFavRest(id, flag);
  }

  void _rateUsButton(BuildContext ctx, Restaurant restaurant) {
    final restaurantProvider = Provider.of<Restaurants>(ctx, listen: false);
    int rating = 0;
    print("Estoy en el rate us button");
    showDialog(
        context: ctx,
        builder: (BuildContext ctx) {
          return new AlertDialog(
            title: new Text("Rate ${restaurant.name}",
                style: TextStyle(color: Colors.black)),
            content: Column(
              children: [
                Text("Our current rate is:"),
                Container(
                  child: StarRate(
                    value: restaurant.rating.round(),
                  ),
                ),
                Text("Help us with your rating for us :)"),
                Container(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return StarRating(
                        onChanged: (index) {
                          setState(() {
                            print("Voy a cambiar de valor RESTAURANTE");
                            rating = index;
                            restaurantProvider.setRating(
                                restaurant, rating + .0);
                          });
                        },
                        value: rating,
                      );
                    },
                  ),
                )
              ],
            ),
            actions: [
              new FlatButton(
                  child: Text("Rate!"),
                  onPressed: () {
                    print("Ya me voy, lup!");
                    restaurantProvider.rateRestaurant(restaurant);
                    Navigator.of(ctx).pop();
                  }),
              new FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    print("Ya me voy, lup!");
                    restaurantProvider.setRating(restaurant, null);
                    Navigator.of(ctx).pop();
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final singleRestaurant = Provider.of<Restaurant>(context, listen: false);
    bool isFav;
    isFav = Provider.of<UserRestaurants>(context)
        .isPartOfFavRest(singleRestaurant.id);
    bool isLoggedIn = Provider.of<Auth>(context).logId == null ? false : true;
    return Container(
      child: InkWell(
        onTap: () => selectedRestaurant(context, singleRestaurant.id),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image.network(
                      singleRestaurant.photoUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Text(
                        singleRestaurant.name,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  if (isLoggedIn)
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                        ),
                        child: IconButton(
                          icon: isFav
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border),
                          onPressed: () {
                            _addToFavorite(singleRestaurant.id, isFav, context);
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () =>
                              _rateUsButton(context, singleRestaurant),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                singleRestaurant.rating
                                    .toStringAsFixed(1)
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 30,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.fastfood),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${singleRestaurant.priceRange}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 3,
                          height: 30,
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                RestaurantFormScreen.routeName,
                                arguments: singleRestaurant.id);
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
