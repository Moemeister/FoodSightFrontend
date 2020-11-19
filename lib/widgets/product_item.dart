import 'package:FoodSight/providers/products.dart';
import 'package:FoodSight/screens/product_info.dart';
import '../providers/userProducts.dart';
import '../screens/product_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../screens/restaurant_detail.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  String id;
  ProductItem(this.id);
  void selectedProduct(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(ProductInformation.routeName, arguments: id);
  }

  void _deleteProduct(String id, BuildContext ctx) {
    Provider.of<Products>(ctx, listen: false).deleteProduct(id);
  }

  void _addToFavorite(String id, bool flag, BuildContext ctx) {
    Provider.of<UserProducts>(ctx, listen: false).updateFavProduct(id, flag);
  }

  @override
  Widget build(BuildContext context) {
    //final String idRestaurant =
    //    ModalRoute.of(context).settings.arguments as String;
    final singleProduct = Provider.of<Product>(context, listen: false);
    bool isFav;
    isFav =
        Provider.of<UserProducts>(context).isPartOfFavProduct(singleProduct.id);
    bool isLoggedIn = Provider.of<Auth>(context).logId == null ? false : true;
    final authType = Provider.of<Auth>(context).loginType;
    final authID = Provider.of<Auth>(context).logId;

    bool showButtons = false;
    if (id != "Usuario" && id == authID) {
      showButtons = true;
    }

    return Container(
      child: InkWell(
        onTap: () => selectedProduct(context, singleProduct.id),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(singleProduct.imageUrl,
                        height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Text(
                            singleProduct.name,
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ))),
                  if (isLoggedIn && authType == "usuario")
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                        ),
                        child: IconButton(
                          icon: isFav
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border),
                          onPressed: () {
                            _addToFavorite(singleProduct.id, isFav, context);
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_money),
                        Text("${singleProduct.price}"),
                        if (isLoggedIn &&
                            authType == "restaurante" &&
                            showButtons)
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  ProductFormScreen.routeName,
                                  arguments: singleProduct.id);
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                        if (isLoggedIn &&
                            authType == "restaurante" &&
                            showButtons)
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteProduct(singleProduct.id, context);
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
