import 'package:FoodSight/screens/restaurants_screen.dart';

import '../models/restaurant.dart';
import '../providers/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantFormScreen extends StatefulWidget {
  static const routeName = '/restaurantFormScreen';
  @override
  _RestaurantFormScreenState createState() => _RestaurantFormScreenState();
}

class _RestaurantFormScreenState extends State<RestaurantFormScreen> {
  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imageUrlFocusNode = FocusNode();
  var _editedRestaurant = Restaurant(
    id: null,
    address: 'None',
    description: '',
    email: '',
    fbUrl: '',
    rating: 0,
    instaUrl: '',
    location: '',
    name: '',
    password: '',
    phone: '',
    photoUrl: '',
    priceCategory: PriceCategory.Affordable,
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_udateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_udateImageUrl);
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _udateImageUrl() {
    if (_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _formKey.currentState.save();
    Provider.of<Restaurants>(context, listen: false)
        .addRestaurant(_editedRestaurant);
    Navigator.of(context).popAndPushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person_add),
                      hintText: '¿Cuál es el nombre de tu restaurante?',
                      labelText: 'Nombre',
                    ),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    onSaved: (value) {
                      _editedRestaurant = Restaurant(
                        id: null,
                        address: _editedRestaurant.address,
                        description: _editedRestaurant.description,
                        email: _editedRestaurant.email,
                        fbUrl: _editedRestaurant.fbUrl,
                        rating: _editedRestaurant.rating,
                        instaUrl: _editedRestaurant.instaUrl,
                        location: _editedRestaurant.location,
                        name: value,
                        password: _editedRestaurant.password,
                        phone: _editedRestaurant.phone,
                        photoUrl: _editedRestaurant.photoUrl,
                        priceCategory: _editedRestaurant.priceCategory,
                      );
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El nombre no puede ser vacío';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Inserte su email',
                      labelText: 'Email',
                    ),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_passFocusNode);
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El email no puede ser vacío';
                      }
                      return null;
                    },
                    focusNode: _emailFocusNode,
                    onSaved: (value) {
                      _editedRestaurant = Restaurant(
                        id: null,
                        address: _editedRestaurant.address,
                        description: _editedRestaurant.description,
                        email: value,
                        fbUrl: _editedRestaurant.fbUrl,
                        rating: _editedRestaurant.rating,
                        instaUrl: _editedRestaurant.instaUrl,
                        location: _editedRestaurant.location,
                        name: _editedRestaurant.name,
                        password: _editedRestaurant.password,
                        phone: _editedRestaurant.phone,
                        photoUrl: _editedRestaurant.photoUrl,
                        priceCategory: _editedRestaurant.priceCategory,
                      );
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.description),
                      hintText: 'Escriba una breve descripción del local',
                      labelText: 'Descripción',
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'La descripción no puede ser vacía';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedRestaurant = Restaurant(
                        id: null,
                        address: _editedRestaurant.address,
                        description: value,
                        email: _editedRestaurant.email,
                        fbUrl: _editedRestaurant.fbUrl,
                        rating: _editedRestaurant.rating,
                        instaUrl: _editedRestaurant.instaUrl,
                        location: _editedRestaurant.location,
                        name: _editedRestaurant.name,
                        password: _editedRestaurant.password,
                        phone: _editedRestaurant.phone,
                        photoUrl: _editedRestaurant.photoUrl,
                        priceCategory: _editedRestaurant.priceCategory,
                      );
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(
                          top: 8,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter URL')
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.camera_alt),
                            labelText: 'Image Url',
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (value) {
                            _editedRestaurant = Restaurant(
                              id: null,
                              address: _editedRestaurant.address,
                              description: _editedRestaurant.description,
                              email: _editedRestaurant.email,
                              fbUrl: _editedRestaurant.fbUrl,
                              rating: _editedRestaurant.rating,
                              instaUrl: _editedRestaurant.instaUrl,
                              location: _editedRestaurant.location,
                              name: _editedRestaurant.name,
                              password: _editedRestaurant.password,
                              phone: _editedRestaurant.phone,
                              photoUrl: value,
                              priceCategory: _editedRestaurant.priceCategory,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Add TextFormFields and ElevatedButton here.
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Agregando tu restaurante...')));
                        }
                      },
                      child: Text('Enviar'),
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
