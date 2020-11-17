import 'package:FoodSight/screens/fav_products_screen.dart';
import 'package:FoodSight/screens/fav_restaurants_screen.dart';

import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/product_form_screen.dart';
import '../screens/restaurant_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';

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

  Widget welcomeText(BuildContext context, String loginType) {
    String txt;
    switch (loginType) {
      case "restaurante":
        txt = "Bienvenido\nRestaurante!";
        break;
      case "usuario":
        txt = "Bienvenido\nUsuario chulo!";
        break;
      case "general":
        txt = "Bienvenido!\n";
        break;
    }
    return Container(
      height: 200,
      padding: EdgeInsets.all(20),
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      color: Theme.of(context).primaryColor,
      child: FittedBox(
        child: Text(
          txt,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 60,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authid = Provider.of<Auth>(context).logId;
    final authType = Provider.of<Auth>(context).loginType;
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          welcomeText(context, authType),
          if (authid != null && authType != "restaurante") SizedBox(height: 20),
          if (authid != null && authType != "restaurante")
            buildListTile(
              'Restaurants',
              Icons.restaurant,
              () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          if (authid != null && authType == "restaurante") SizedBox(height: 20),
          if (authid != null && authType == "restaurante")
            buildListTile(
              'Edit your information',
              Icons.edit,
              () {
                Navigator.of(context).pushNamed(RestaurantFormScreen.routeName,
                    arguments: authid);
              },
            ),
          if (authid != null && authType == "restaurante") SizedBox(height: 20),
          if (authid != null && authType == "restaurante")
            buildListTile(
              'Add New Product',
              Icons.add_circle_outline,
              () {
                Navigator.of(context)
                    .popAndPushNamed(ProductFormScreen.routeName);
              },
            ),
          if (authid == null) SizedBox(height: 20),
          if (authid == null)
            buildListTile(
              'Login',
              Icons.lightbulb_outline,
              () {
                Navigator.of(context).pushNamed(AuthScreen.routeName);
              },
            ),
          SizedBox(height: 20),
          if (authid != null && authType == "usuario")
            buildListTile(
              'Show Favorite Restaurants',
              Icons.favorite,
              () {
                Navigator.of(context).pushNamed(FavRestaurantsScreen.routeName);
              },
            ),
          if (authid != null && authType == "usuario") SizedBox(height: 20),
          if (authid != null && authType == "usuario")
            buildListTile(
              'Show Favorite Products',
              Icons.favorite,
              () {
                Navigator.of(context).pushNamed(FavProductsScreen.routeName);
              },
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    ));
  }
}
