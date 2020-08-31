import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopkeeper/appbar/appbar.dart';
import 'package:shopkeeper/constants/colors.dart';
import 'package:shopkeeper/homepage.dart';
import 'package:shopkeeper/models/oders-items.dart';
import 'package:shopkeeper/widgets/my-button.dart';

import 'constants/appconstants.dart';
import 'constants/firebase-collections.dart';

class AddOrderItem extends StatefulWidget {
  bool isForEdit;
  final OrderItem passOrderItem;

  AddOrderItem(this.isForEdit, {Key key, this.passOrderItem}) : super(key: key);

  @override
  _AddOrderItemState createState() => _AddOrderItemState();
}

class _AddOrderItemState extends State<AddOrderItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // var _purchaseController = TextEditingController();
  var _quantityController = TextEditingController();
  var _gstslabController = TextEditingController();
  var _sellingController = TextEditingController();
  bool _autoValidate = false;
  bool isRefresh = false;
  OrderItem orderItem;
  double itemCost = 0;
  @override
  Widget build(BuildContext context) {
    print("build $orderItem $isRefresh");

    if (!isRefresh) {
      orderItem = OrderItem();
    } else {
      print("pur ${orderItem.purchasePrice}");
    }
    return Scaffold(
      appBar: MyAppBar(
        "Add Order Items",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CupertinoButton(
                  onPressed: () {
                    startProductsPage();
                  },
                  child: Text(
                    isRefresh
                        ? orderItem.getProductCode
                        : "Select Product Code",
                    style: boldtext.copyWith(color: primaryColor),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    startProductsPage();
                  },
                  child: Text(
                    isRefresh
                        ? orderItem.getProductName
                        : "Select Product Name",
                    style: boldtext.copyWith(color: primaryColor),
                  ),
                ),
                // SizedBox(height: 20.0),
                // TextFormField(
                //   controller: _purchaseController,
                //   cursorColor: primaryColor,
                //   decoration: new InputDecoration(
                //     labelText: "Purchased price",
                //     fillColor: Colors.white,
                //     border: new OutlineInputBorder(
                //       borderRadius: new BorderRadius.circular(10.0),
                //       borderSide: new BorderSide(),
                //     ),
                //   ),
                //   onSaved: (val) =>
                //       orderItem.purchasePrice = double.tryParse(val) ?? 0.00,
                //   validator: (val) {
                //     if (val.length == 0) {
                //       return "Purchased price cannot be empty";
                //     } else {
                //       return null;
                //     }
                //   },
                //   inputFormatters: [
                //     WhitelistingTextInputFormatter(
                //         RegExp(r'^(\d+)?\.?\d{0,2}')),
                //   ],
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                //   textInputAction: TextInputAction.next,
                //   onFieldSubmitted: (v) => FocusScope.of(context).nextFocus(),
                //   style: boldtext,
                // ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _gstslabController,
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    labelText: "GST slab",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onSaved: (val) => orderItem.gstSlab = val,
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
                  controller: _quantityController,
                  cursorColor: primaryColor,
                  decoration: new InputDecoration(
                    labelText: "Quantity",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (v) {
                    setState(() {
                      itemCost =
                          int.parse(v) * double.parse(_sellingController.text);
                    });
                  },
                  onSaved: (val) => orderItem.quantity = int.tryParse(val) ?? 0,
                  validator: (val) {
                    if (val.length == 0) {
                      return "Quantity cannot be empty";
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _sellingController,
                        cursorColor: primaryColor,
                        decoration: new InputDecoration(
                          labelText: "Selling price",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: new BorderSide(),
                          ),
                        ),
                        onChanged: (v) {
                          setState(() {
                            itemCost = int.parse(_quantityController.text) *
                                double.parse(v);
                          });
                        },
                        onSaved: (val) => orderItem.sellingPrice =
                            double.tryParse(val) ?? 0.00,
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
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.done,
                        style: boldtext,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Total: " + itemCost.toString(),
                      style: boldtext.copyWith(color: crossColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                widget.isForEdit
                    ? MyButton(
                        onButtonClick: () {
                          // deleteData(
                          //     productCollection, widget.document.documentID);
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

  onActionTapped(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // var data = {
      //   productCode: _productCode,
      //   productName: _productName,
      //   productGSTSlab: _gstSlab,
      //   productSellingPrice: _sellingPrice,
      //   productPurchasePrice: _purchasePrice,
      // };
      if (widget.isForEdit) {
        // updateData(productCollection, widget.document.documentID, data);
        // Navigator.pop(context, "GET");
      } else {
        // createData(productCollection, data);
        Navigator.pop(context, orderItem);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void startProductsPage() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => HomePage(isViewMode: true))).then((value) {
      if (value != null) {
        DocumentSnapshot doc = value;
        orderItem.setProductCode = doc.data[productCode];
        orderItem.setProductName = doc.data[productName];
        orderItem.setPurchasePrice =
            double.tryParse(doc.data[productPurchasePrice]) ?? 10.00;
        orderItem.setSellingPrice =
            double.tryParse(doc.data[productSellingPrice]) ?? 12.00;
        orderItem.setGstSlab = doc.data[productGSTSlab];
        orderItem.setQuantity = 1;
        setState(() {
          isRefresh = true;
          // _purchaseController.text = orderItem.purchasePrice.toString();
          _quantityController.text = orderItem.getQuantity.toString();
          _gstslabController.text = orderItem.getGstSlab.toString();
          _sellingController.text = orderItem.getSellingPrice.toString();
          itemCost = double.parse(orderItem.getSellingPrice.toString());
        });
      }
    });
  }
}
