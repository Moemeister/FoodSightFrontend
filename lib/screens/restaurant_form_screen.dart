import '../helpers/location_helper.dart';

import '../widgets/location_input.dart';

import 'dart:io';
import '../models/restaurant.dart';
import '../providers/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantFormScreen extends StatefulWidget {
  static const routeName = '/restaurantFormScreen';
  @override
  _RestaurantFormScreenState createState() => _RestaurantFormScreenState();
}

class _RestaurantFormScreenState extends State<RestaurantFormScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
  var _initValues = {
    'address': 'None',
    'description': '',
    'email': '',
    'fbUrl': '',
    'rating': 10,
    'instaUrl': '',
    'location': '',
    'name': '',
    'password': '',
    'phone': '',
    'photoUrl': '',
  };

  var _isInit = true;
  var _isloading = false;
  var latlong;
  double lat;
  double long;
  var previewLocationUrl;
  var producId;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_udateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      producId = ModalRoute.of(context).settings.arguments as String;
      if (producId != null) {
        _editedRestaurant =
            Provider.of<Restaurants>(context, listen: false).findById(producId);
        _initValues = {
          'address': _editedRestaurant.address,
          'description': _editedRestaurant.description,
          'email': _editedRestaurant.email,
          'fbUrl': _editedRestaurant.fbUrl,
          'instaUrl': _editedRestaurant.instaUrl,
          'location': _editedRestaurant.location,
          'name': _editedRestaurant.name,
          //'password': _editedRestaurant.password,
          'phone': _editedRestaurant.phone,
          'photoUrl': _editedRestaurant.photoUrl,
        };
        _imageUrlController.text = _editedRestaurant.photoUrl;
        latlong = _editedRestaurant.location.split(",");
        lat = double.parse(latlong[0]);
        long = double.parse(latlong[1]);
        previewLocationUrl = LocationHelper.generateLocationPreviewImage(
            latitude: lat, longitud: long);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  File image;

  Future<void> _takePicture() async {
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile != null) {
      setState(() {
        image = imageFile;
      });
    }
  }

  Future<void> _selectPicture() async {
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile != null) {
      setState(() {
        image = imageFile;
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState.validate()) {
      Fluttertoast.showToast(
          msg: "Restaurant Saved",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white);
      _formKey.currentState.save();
      setState(() {
        _isloading = true;
      });
      if (_editedRestaurant.id != null) {
        _selectResAddress(lat, long);
        await Provider.of<Restaurants>(context, listen: false).updateRestaurant(
            _editedRestaurant.id, _editedRestaurant, image, _pickedLocation);
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).popAndPushNamed('/');
      } else {
        try {
          await Provider.of<Restaurants>(context, listen: false)
              .addRestaurant(_editedRestaurant, image, _pickedLocation)
              .then((_) {
            setState(() {
              _isloading = false;
            });
            Navigator.of(context).popAndPushNamed('/');
          });
        } catch (error) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('An error ocurred'),
              content: Text('Something when wrong' + error.toString()),
              actions: [
                FlatButton(
                  child: Text('Okaay'),
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed('/');
                  },
                )
              ],
            ),
          );
        } finally {
          setState(() {
            _isloading = false;
          });
          Navigator.of(context).popAndPushNamed('/');
        }
      }
    }
  }

  RestaurantLocation _pickedLocation;

  void _selectResAddress(double lat, double lng) {
    _pickedLocation = RestaurantLocation(latitude: lat, longitude: lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Restaurant Form'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              }),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        //name
                        TextFormField(
                          initialValue: _initValues['name'],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person_add),
                            hintText: '¿Cuál es el nombre de tu restaurante?',
                            labelText: 'Nombre',
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                          onSaved: (value) {
                            _editedRestaurant = Restaurant(
                              id: _editedRestaurant.id,
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
                        //email
                        TextFormField(
                          initialValue: _initValues['email'],
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
                              id: _editedRestaurant.id,
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
                        //password
                        if (producId == null)
                          TextFormField(
                            initialValue: _initValues['password'],
                            decoration: const InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            onFieldSubmitted: (value) {
                              //FocusScope.of(context).requestFocus(_emailFocusNode);
                            },
                            onSaved: (value) {
                              _editedRestaurant = Restaurant(
                                id: _editedRestaurant.id,
                                address: _editedRestaurant.address,
                                description: _editedRestaurant.description,
                                email: _editedRestaurant.email,
                                fbUrl: _editedRestaurant.fbUrl,
                                rating: _editedRestaurant.rating,
                                instaUrl: _editedRestaurant.instaUrl,
                                location: _editedRestaurant.location,
                                name: _editedRestaurant.name,
                                password: value,
                                phone: _editedRestaurant.phone,
                                photoUrl: _editedRestaurant.photoUrl,
                                priceCategory: _editedRestaurant.priceCategory,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'El password no puede estar vacío';
                              }
                              return null;
                            },
                            //textInputAction: TextInputAction.next,
                          ),
                        //description
                        TextFormField(
                          initialValue: _initValues['description'],
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
                              id: _editedRestaurant.id,
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
                        //phone
                        TextFormField(
                          initialValue: _initValues['phone'],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone),
                            hintText:
                                'Agrega un teléfono para que te contacten!',
                            labelText: 'Teléfono',
                          ),
                          onFieldSubmitted: (value) {
                            //FocusScope.of(context).requestFocus(_passFocusNode);
                          },
                          keyboardType: TextInputType.phone,
                          //textInputAction: TextInputAction.next,
                          //focusNode: _emailFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'El teléfono no debe estar vacío';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedRestaurant = Restaurant(
                              id: _editedRestaurant.id,
                              address: _editedRestaurant.address,
                              description: _editedRestaurant.description,
                              email: _editedRestaurant.email,
                              fbUrl: _editedRestaurant.fbUrl,
                              rating: _editedRestaurant.rating,
                              instaUrl: _editedRestaurant.instaUrl,
                              location: _editedRestaurant.location,
                              name: _editedRestaurant.name,
                              password: _editedRestaurant.password,
                              phone: value,
                              photoUrl: _editedRestaurant.photoUrl,
                              priceCategory: _editedRestaurant.priceCategory,
                            );
                          },
                        ),
                        //Facebook
                        TextFormField(
                          initialValue: _initValues['fbUrl'],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'Adjunta tu link de Facebook',
                            labelText: 'Facebook url',
                          ),
                          onFieldSubmitted: (value) {
                            //FocusScope.of(context).requestFocus(_passFocusNode);
                          },
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.next,
                          //focusNode: _emailFocusNode,
                          onSaved: (value) {
                            _editedRestaurant = Restaurant(
                              id: _editedRestaurant.id,
                              address: _editedRestaurant.address,
                              description: _editedRestaurant.description,
                              email: _editedRestaurant.email,
                              fbUrl: value,
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
                        //Instagram
                        TextFormField(
                          initialValue: _initValues['fbUrl'],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.alternate_email),
                            hintText: 'Adjunta tu link de Instagram',
                            labelText: 'Instagram url',
                          ),
                          onFieldSubmitted: (value) {
                            //FocusScope.of(context).requestFocus(_passFocusNode);
                          },
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.next,
                          //focusNode: _emailFocusNode,
                          onSaved: (value) {
                            _editedRestaurant = Restaurant(
                              id: _editedRestaurant.id,
                              address: _editedRestaurant.address,
                              description: _editedRestaurant.description,
                              email: _editedRestaurant.email,
                              fbUrl: _editedRestaurant.fbUrl,
                              rating: _editedRestaurant.rating,
                              instaUrl: value,
                              location: _editedRestaurant.location,
                              name: _editedRestaurant.name,
                              password: _editedRestaurant.password,
                              phone: _editedRestaurant.phone,
                              photoUrl: _editedRestaurant.photoUrl,
                              priceCategory: _editedRestaurant.priceCategory,
                            );
                          },
                        ),
                        //photo
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              child: Builder(builder: (context) {
                                if (image == null &&
                                    _initValues['photoUrl'] == '') {
                                  return Text('No Image Selected');
                                } else if (image != null) {
                                  return Image.file(image);
                                } else {
                                  return FittedBox(
                                    child: Image.network(
                                      _initValues['photoUrl'].toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                              }),
                            ),
                            Column(
                              children: [
                                Container(
                                  child: FlatButton.icon(
                                    icon: Icon(Icons.photo),
                                    label: Text('Select a Picture'),
                                    onPressed: _selectPicture,
                                  ),
                                ),
                                Container(
                                  child: FlatButton.icon(
                                    icon: Icon(Icons.camera),
                                    label: Text('Take a Picture'),
                                    onPressed: _takePicture,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //location
                        SizedBox(
                          height: 10,
                        ),
                        LocationInput(_selectResAddress, previewLocationUrl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
