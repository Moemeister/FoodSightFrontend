import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../screens/restaurant_detail.dart';
import '../screens/restaurant_form_screen.dart';

class RestaurantItem extends StatelessWidget {
  void selectedRestaurant(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(RestaurantDetail.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final singleRestaurant = Provider.of<Restaurant>(context, listen: false);
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
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {}, //TODO add to favorite for user
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
                          onPressed: () {}, //TODO Show a dialog, to vote rating
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
                                singleRestaurant.rating.toString(),
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
