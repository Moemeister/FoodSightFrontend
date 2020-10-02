import 'package:flutter/material.dart';

//Colores de la app
const _appBarColor = const Color(0xFF0099AD);
const _buttonOrangeColor = const Color(0xFFFB7813);
const _backgroundWhite = const Color(0xFFF7F7EE);
const _theGreen = const Color(0xFFB6EB7A);

void main() => runApp(FoodSight());

class FoodSight extends StatefulWidget {
  @override
  _FoodSightState createState() => _FoodSightState();
}

class _FoodSightState extends State<FoodSight> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _backgroundWhite,
        appBar: AppBar(
          title: Text('FoodSight'),
          backgroundColor: _appBarColor,
        ),
        body: null,
      ),
    );
  }
}
