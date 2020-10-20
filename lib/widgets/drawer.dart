import 'package:flutter/material.dart';

import '../screens/restaurants_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          //fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        Container(
          height: 200,
          padding: EdgeInsets.all(20),
          width: double.infinity,
          alignment: Alignment.bottomRight,
          color: Theme.of(context).primaryColor,
          child: Text(
            'User Profile',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 50,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20),
        buildListTile(
          'Restaurants',
          Icons.restaurant,
          () {
            Navigator.of(context).pushNamed(RestaurantsScreen.screenRoute);
          },
        ),
      ],
    ));
  }
}
