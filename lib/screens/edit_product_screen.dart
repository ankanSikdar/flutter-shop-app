import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Product _product =
      Product(id: null, title: '', description: '', price: 0.0, imageUrl: '');

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
  }

  void _updateImageUrl() {
    if (_imageUrlFocusNode.hasFocus) {
      String value = _imageUrlController.text;
      if (value.isEmpty ||
          !value.startsWith('http') ||
          !value.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  void _onSubmitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(_product.title);
    print(_product.description);
    print(_product.price);
    print(_product.imageUrl);
    _clearForm();
  }

  void _clearForm() {
    _formKey.currentState.reset();
    _imageUrlController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _product = Product(
                      id: _product.id,
                      title: value,
                      description: _product.description,
                      price: _product.price,
                      imageUrl: _product.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter a Title';
                    } else if (value.length < 3) {
                      return 'Title should be more than 3 characters';
                    } else if (value.length > 25) {
                      return 'Title cannot be greater than 25 characters';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _product = Product(
                      id: _product.id,
                      title: _product.title,
                      description: _product.description,
                      price: double.parse(value),
                      imageUrl: _product.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter a Price';
                    } else if (double.tryParse(value) == null) {
                      return 'Plase Enter a Valid Number';
                    } else if (double.parse(value) <= 0) {
                      return 'Price cannot be less than or equal to 0';
                    } else if (double.parse(value) > 99999.99) {
                      return 'Price should be less than ₹1 Lakhs';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    _product = Product(
                      id: _product.id,
                      title: _product.title,
                      description: value,
                      price: _product.price,
                      imageUrl: _product.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter a Description';
                    } else if (value.length < 10) {
                      return 'Description should be greater than 10 characters';
                    } else if (value.length > 100) {
                      return 'Description cannot be greater than 100 characters';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      )),
                      margin: EdgeInsets.only(top: 10, right: 10),
                      child: _imageUrlController.text.isEmpty
                          ? Center(
                              child: Text(
                                'Image will be shown here',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        focusNode: _imageUrlFocusNode,
                        controller: _imageUrlController,
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            description: _product.description,
                            price: _product.price,
                            imageUrl: value,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Image Url cannot be Empty';
                          } else if (!value.startsWith('http') ||
                              !value.startsWith('https')) {
                            return 'Please Enter a valid URL';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _onSubmitForm();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onSubmitForm,
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
        ));
  }
}
