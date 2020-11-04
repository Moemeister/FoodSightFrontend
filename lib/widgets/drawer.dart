import 'package:FoodSight/screens/auth_screen.dart';
import 'package:FoodSight/screens/product_form_screen.dart';
import 'package:FoodSight/screens/restaurant_form_screen.dart';
import 'package:flutter/material.dart';

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
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        SizedBox(height: 20),
        buildListTile(
          'Add New Restaurant',
          Icons.add_circle_outline,
          () {
            Navigator.of(context).pushNamed(RestaurantFormScreen.routeName);
          },
        ),
        SizedBox(height: 20),
        buildListTile(
          'Add New Product',
          Icons.add_circle_outline,
          () {
            Navigator.of(context).popAndPushNamed(ProductFormScreen.routeName);
          },
        ),
        SizedBox(height: 20),
        buildListTile(
          'Login logic',
          Icons.lightbulb_outline,
          () {
            Navigator.of(context).pushNamed(AuthScreen.routeName);
          },
        ),
      ],
    ));
  }
}
