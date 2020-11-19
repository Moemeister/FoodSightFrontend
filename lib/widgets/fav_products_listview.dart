import 'package:FoodSight/providers/products.dart';
import 'package:FoodSight/providers/userProducts.dart';
import 'package:FoodSight/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/userRestaurants.dart';
import 'restaurant_item.dart';

class FavProductsListView extends StatelessWidget {
  final String searchValue;

  FavProductsListView(this.searchValue);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<UserProducts>(context);
    final favProductsIds = productData.favProducts;

    if (searchValue == "null") {
      final products =
          Provider.of<Products>(context).getFavProductList(favProductsIds);
      return Center(
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem("Usuario"),
          ),
        ),
      );
    } else {
      final products = Provider.of<Products>(context)
          .getFavListByNameSearch(favProductsIds, searchValue);
      return Center(
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem("Usuario"),
          ),
        ),
      );
    }
  }
}
