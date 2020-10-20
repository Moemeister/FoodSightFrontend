import 'package:flutter/material.dart';

class RestaurantsScreen extends StatelessWidget {

  static final screenRoute = "/restaurantsScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurantes")
      ),
      body: 
        Center(child: 
          Text("Hello!")
       )
    );
  }
}