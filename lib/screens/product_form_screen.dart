import 'package:FoodSight/models/product.dart';

import '../models/product.dart';
import '../providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    image: '',
    price: 0.0,
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_udateImageUrl);
    super.initState();
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

  void _saveForm() {
    Fluttertoast.showToast(
        msg: "Product Saved",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Theme.of(context).accentColor,
        textColor: Colors.white);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);

    Navigator.of(context).popAndPushNamed('/');
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
                      hintText: '¿Cuál es el nombre del platillo?',
                      labelText: 'Platillo',
                    ),
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_descFocusNode);
                    },
                    onSaved: (value) {
                      print(value);
                      _editedProduct = Product(
                          id: null,
                          name: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          rating: _editedProduct.rating,
                          image: _editedProduct.image);
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
                      icon: Icon(Icons.description),
                      hintText: 'Escriba una breve descripción del platillo',
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
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: null,
                          name: _editedProduct.name,
                          description: value,
                          price: _editedProduct.price,
                          rating: _editedProduct.rating,
                          image: _editedProduct.image);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.description),
                      hintText: 'Escriba el precio del platillo',
                      labelText: 'Precio',
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'El precio no puede ser vacio';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: null,
                          name: _editedProduct.name,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          rating: _editedProduct.rating,
                          image: _editedProduct.image);
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
                            _editedProduct = Product(
                                id: null,
                                name: _editedProduct.name,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                rating: _editedProduct.rating,
                                image: value);
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
                              content: Text('Agregando tu Producto...')));
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
