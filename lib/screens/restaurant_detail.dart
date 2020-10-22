import 'package:flutter/material.dart';

class RestaurantDetail extends StatelessWidget {
  static final routeName = "/restaurant-detail";
  final String id;

  RestaurantDetail({this.id});

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Restaurant Detail"),
            Icon(Icons.info),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      body: Center(
        child: Text("${id}"),
      ),
    );
  }
}
