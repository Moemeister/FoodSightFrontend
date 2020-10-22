import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../screens/restaurant_info.dart';

class RestaurantDetail extends StatelessWidget {
  static final routeName = "/restaurant-detail";
  final String id;

  void tappedInfo(BuildContext ctx, id) {
    Navigator.of(ctx).pushNamed(RestaurantInformation.routeName, arguments: id);
  }

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
            Text("Restaurant Detail ${id}"),
            InkWell(
              onTap: () => tappedInfo(context, id),
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
