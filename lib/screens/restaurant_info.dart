import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurants.dart';

class RestaurantInformation extends StatelessWidget {
  static final String routeName = "/restaurant-information";

  @override
  Widget build(BuildContext context) {
    final String idRestaurant =
        ModalRoute.of(context).settings.arguments as String;
    final restaurantsData = Provider.of<Restaurants>(context);
    final restaurant = restaurantsData.findById(idRestaurant);
    return Scaffold(
        appBar: AppBar(
          title: Text("${restaurant.name} Information"),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  restaurant.photoUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: Text("${restaurant.name}",
                          style: TextStyle(
                            fontSize: 24,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Description: ", style: TextStyle(fontSize: 20)),
                        Expanded(
                            child: Text("${restaurant.description}",
                                style: TextStyle(fontSize: 20),
                                overflow: TextOverflow.fade)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Location: ", style: TextStyle(fontSize: 20)),
                        Text("${restaurant.location}",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Email: ", style: TextStyle(fontSize: 20)),
                        Text("${restaurant.email}",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Facebook: ", style: TextStyle(fontSize: 20)),
                        Expanded(
                            child: Text("${restaurant.fbUrl}",
                                style: TextStyle(fontSize: 20))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Instagram: ", style: TextStyle(fontSize: 20)),
                        Expanded(
                            child: Text(
                          "${restaurant.instaUrl}",
                          style: TextStyle(fontSize: 20),
                        )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
