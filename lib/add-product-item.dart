import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopkeeper/appbar/appbar.dart';
import 'package:shopkeeper/constants/appconstants.dart';
import 'package:shopkeeper/constants/colors.dart';
import 'package:shopkeeper/constants/firebase-collections.dart';
import 'package:shopkeeper/firebase-crud.dart';
import 'package:shopkeeper/widgets/my-button.dart';

class AddProductItem extends StatefulWidget {
  final bool isForEdit;
  final DocumentSnapshot document;

  AddProductItem(this.isForEdit, {Key key, this.document}) : super(key: key);
  @override
  _AddProductItemState createState() => _AddProductItemState();
}

class _AddProductItemState extends State<AddProductItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _productCode = "";
  String _productName = "";
  String _purchasePrice = "0.00";
  String _gstSlab = "0";
  String _sellingPrice = "0.00";

  bool _autoValidate = false;

  onActionTapped(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var data = {
        productCode: _productCode,
        productName: _productName,
        productGSTSlab: _gstSlab,
        productSellingPrice: _sellingPrice,
        productPurchasePrice: _purchasePrice,
      };
      if (widget.isForEdit) {
        updateData(productCollection, widget.document.documentID, data);
        Navigator.pop(context, "GET");
      } else {
        createData(productCollection, data);
        Navigator.pop(context, "GET");
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        "Add Item",
        actionTapped: () => onActionTapped(context),
        showActionButton: true,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: widget.isForEdit
                      ? widget.document.data["product_code"]
                      : null,
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    labelText: "Product code",
                    fillColor: primaryColor,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Product code cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => _productCode = val,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
                  style: boldtext,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: widget.isForEdit
                      ? widget.document.data["product_name"]
                      : null,
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    labelText: "Product name",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onSaved: (val) => _productName = val,
                  validator: (val) {
                    if (val.length == 0) {
                      return "Product name cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
                  style: boldtext,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: widget.isForEdit
                      ? widget.document.data["purchased_price"]
                      : null,
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    labelText: "Purchased price",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onSaved: (val) => _purchasePrice = val,
                  validator: (val) {
                    if (val.length == 0) {
                      return "Purchased price cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter(
                        RegExp(r'^(\d+)?\.?\d{0,2}')),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
                  style: boldtext,
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  initialValue: widget.isForEdit
                      ? widget.document.data["gst_slab"]
                      : null,
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    labelText: "GST slab",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onSaved: (val) => _gstSlab = val,
                  validator: (val) {
                    if (val.length == 0) {
                      return "GST slab cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
                  style: boldtext,
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  initialValue: widget.isForEdit
                      ? widget.document.data["selling_price"]
                      : null,
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    labelText: "Selling price",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onSaved: (val) => _sellingPrice = val,
                  validator: (val) {
                    if (val.length == 0) {
                      return "Selling price cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter(
                        RegExp(r'^(\d+)?\.?\d{0,2}')),
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  style: boldtext,
                ),
                SizedBox(
                  height: 20,
                ),
                widget.isForEdit
                    ? MyButton(
                        onButtonClick: () {
                          deleteData(
                              productCollection, widget.document.documentID);
                          Navigator.pop(context, "DELETE");
                        },
                        buttonName: "Delete")
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
