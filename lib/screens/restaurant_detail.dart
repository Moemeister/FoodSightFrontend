import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class RestaurantDetail extends StatelessWidget {
  static final routeName = "/restaurant-detail";
  final String id;

  /*void tappedInfo (BuildContext ctx) {
    Navigator.of(ctx).pushNamed()
  }*/

  RestaurantDetail({this.id});

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments as String;
    final productsData = Provider.of<Products>(context, listen: false);
    final products = productsData.items;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Restaurant Detail"),
            InkWell(
              onTap: null, //() => tappedInfo(context),
              child: Icon(Icons.info),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(),
          ),
          itemCount: products.length,
        ),
      ),
    );
  }
}
