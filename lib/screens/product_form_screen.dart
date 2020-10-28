import '../models/product.dart';

import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProductFormScreen extends StatefulWidget {
  static const routeName = '/ProductFormScreen';
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _scaffoldFormKey = GlobalKey<ScaffoldState>();
  final _nameFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imageUrlFocusNode = FocusNode();
  var _editedProduct = Product(
    id: null,
    name: '',
    description: '',
    rating: 0.0,
    imageUrl: '',
    price: 0.0,
    idRestaurant: 'r2',
  );

  var _initValues = {
    'name': '',
    'description': '',
    'rating': '',
    'price': '',
    'imageUrl': '',
    'idRestaurant': 'r2'
  };
  var _isInit = true;
  var _isloading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_udateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'rating': _editedProduct.rating.toString(),
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_udateImageUrl);
    _nameFocusNode.dispose();
    _descFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _udateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  var imageFile;
  Future<void> _takePicture() async {
    imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    print(imageFile);
  }

  void _saveForm() {
    if (_formKey.currentState.validate()) {
      Fluttertoast.showToast(
          msg: "Product Saved",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white);
      _formKey.currentState.save();
      setState(() {
        _isloading = true;
      });
      _editedProduct.imageUrl = imageFile.toString();
      if (_editedProduct.id != null) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        Navigator.of(context).popAndPushNamed('/');
      } else {
        Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct)
            .then((_) {
          setState(() {
            _isloading = false;
          });
          Navigator.of(context).popAndPushNamed('/');
        });
      }
    }

    //Navigator.of(context).popAndPushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldFormKey,
      appBar: AppBar(
        title: Text('Product Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
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
                        TextFormField(
                          initialValue: _initValues['name'],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person_add),
                            hintText: '¿Cuál es el nombre del platillo?',
                            labelText: 'Platillo',
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_descFocusNode);
                          },
                          focusNode: _nameFocusNode,
                          onSaved: (value) {
                            print(value);
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                name: value,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                rating: _editedProduct.rating,
                                imageUrl: _editedProduct.imageUrl,
                                idRestaurant: _editedProduct.idRestaurant);
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
                          initialValue: _initValues['description'],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.description),
                            hintText:
                                'Escriba una breve descripción del platillo',
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
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                name: _editedProduct.name,
                                description: value,
                                price: _editedProduct.price,
                                rating: _editedProduct.rating,
                                imageUrl: _editedProduct.imageUrl,
                                idRestaurant: _editedProduct.idRestaurant);
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: const InputDecoration(
                            icon: Icon(Icons.description),
                            hintText: 'Escriba el precio del platillo',
                            labelText: 'Precio',
                          ),
                          maxLines: 3,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          focusNode: _priceFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'El precio no puede ser vacio';
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_imageUrlFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                name: _editedProduct.name,
                                description: _editedProduct.description,
                                price: double.parse(value),
                                rating: _editedProduct.rating,
                                imageUrl: _editedProduct.imageUrl,
                                idRestaurant: _editedProduct.idRestaurant);
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
                              child: FlatButton.icon(
                                icon: Icon(Icons.camera),
                                label: Text('Take a Picture'),
                                onPressed: _takePicture,
                              ),
                              // child: TextFormField(
                              //   decoration: const InputDecoration(
                              //     icon: Icon(Icons.camera_alt),
                              //     labelText: 'Image Url',
                              //   ),
                              //   keyboardType: TextInputType.url,
                              //   textInputAction: TextInputAction.done,
                              //   controller: _imageUrlController,
                              //   focusNode: _imageUrlFocusNode,
                              //   onFieldSubmitted: (_) {
                              //     _saveForm();
                              //   },
                              //   onSaved: (value) {
                              //     _editedProduct = Product(
                              //         id: _editedProduct.id,
                              //         name: _editedProduct.name,
                              //         description: _editedProduct.description,
                              //         price: _editedProduct.price,
                              //         rating: _editedProduct.rating,
                              //         imageUrl: value,
                              //         idRestaurant: _editedProduct.idRestaurant);
                              //   },
                              // ),
                            ),
                          ],
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
