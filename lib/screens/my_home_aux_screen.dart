import 'package:flutter/material.dart';

import '../screens/restaurants_screen.dart';
import '../widgets/drawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void selectRestaurant(BuildContext ctx) {
  Navigator.of(ctx).pushNamed(RestaurantsScreen.screenRoute);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FoodSight'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () => selectRestaurant(context),
              child: Container(
                margin: EdgeInsets.all(10),
                height: 50,
                width: 200,
                color: Theme.of(context).accentColor,
                child: Center(child: Text("Catalogo de Restaurante")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
