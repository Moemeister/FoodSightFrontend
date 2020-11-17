import 'package:FoodSight/providers/products.dart';

import '../models/product.dart';
import 'map_screen.dart';

import '../helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/restaurants.dart';
import '../widgets/star_rate.dart';

class ProductInformation extends StatelessWidget {
  static final String routeName = "/product-information";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final String idProduct =
        ModalRoute.of(context).settings.arguments as String;
    final productData = Provider.of<Products>(context);
    final product = productData.findById(idProduct);
    return Scaffold(
      appBar: AppBar(
        title: Text("${product.name} Information"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "${product.name}",
                        style: TextStyle(
                          fontSize: 28,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).accentColor),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description:",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                        ),
                                      ),
                                      Container(
                                        width: mediaQuery.width - 65,
                                        child: Text("${product.description}",
                                            style: TextStyle(fontSize: 20),
                                            overflow: TextOverflow.visible),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              width: mediaQuery.width - 65,
                              child: Text(
                                "Price:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              width: mediaQuery.width - 65,
                              child: Text("${product.price}",
                                  style: TextStyle(fontSize: 20),
                                  overflow: TextOverflow.visible),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
