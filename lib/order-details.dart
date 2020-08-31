import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopkeeper/appbar/appbar.dart';
import 'package:shopkeeper/constants/appconstants.dart';
import 'package:shopkeeper/constants/colors.dart';
import 'package:shopkeeper/constants/common-utils.dart';
import 'package:shopkeeper/constants/firebase-collections.dart';
import 'package:shopkeeper/firebase-crud.dart';

class OrderDetails extends StatefulWidget {
  String documentID;
  String orderdt;
  String orderAmount;
  OrderDetails(this.documentID, this.orderdt, this.orderAmount);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Stream<QuerySnapshot> orderItems;
  String textMessage = "";
  TextEditingController _dialogController = TextEditingController();
  @override
  void initState() {
    super.initState();
    orderItems =
        fetchSubData('orders/' + widget.documentID, 'items', productCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        "Order Details",
        showBackButton: true,
        showActionButton: false,
        actionText: widget.orderAmount,
      ),
      body: Column(
        children: <Widget>[
          Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5.0,
            margin: EdgeInsets.all(8.0),
            shadowColor: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CupertinoButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.print),
                        SizedBox(width: 5),
                        Text(
                          "Print Receipt",
                          style: boldtext,
                        ),
                      ],
                    ),
                    onPressed: () => _displayDialog(context)),
                CupertinoButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.repeat),
                        SizedBox(width: 5),
                        Text(
                          "Repeat Order",
                          style: boldtext,
                        ),
                      ],
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              "Order placed on: " + widget.orderdt,
              style: boldtext,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 150,
            child: StreamBuilder(
                stream: orderItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Text("No items found.", style: errortext),
                    );
                  } else {
                    setMessage(snapshot.data.documents);
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shadowColor: crossColor,
                            margin: EdgeInsets.all(10),
                            color: Colors.green[50],
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    snapshot.data.documents[index]
                                            .data["product_code"] +
                                        " - " +
                                        snapshot.data.documents[index]
                                            .data["product_name"],
                                    style: boldtext.copyWith(
                                        color: primaryColor,
                                        fontSize: 22.0,
                                        letterSpacing: 1.25),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot.data.documents[index]
                                            .data['quantity'] +
                                        " Q x " +
                                        snapshot.data.documents[index]
                                            .data["selling_price"]
                                            .toString(),
                                    style: normaltext.copyWith(
                                        fontSize: 20, letterSpacing: 1.5),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    getPrice(snapshot, index),
                                    style: normaltext.copyWith(
                                        fontSize: 20, letterSpacing: 1.5),
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            // margin: EdgeInsets.all(10),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    );
  }

  String getPrice(snapshot, index) {
    int q =
        int.parse(snapshot.data.documents[index].data['quantity'].toString());
    double s = double.parse(
        snapshot.data.documents[index].data['selling_price'].toString());
    return (q * s).toString();
  }

  static const platform = const MethodChannel('sendSms');
  Future sendSms(Stream<QuerySnapshot> orderItems) async {
    print("SendSMS");
    try {
      final String result =
          await platform.invokeMethod('send', <String, dynamic>{
        "phone": "+91" + _dialogController.text,
        "msg": textMessage,
      }); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  setMessage(documents) async {
    textMessage = "Bill Amount";
    await documents.map((v) {
      textMessage = textMessage +
          "\n" +
          v.data['product_name'] +
          " : " +
          v.data["quantity"] +
          " * " +
          v.data["selling_price"] +
          " = " +
          (multiply(v.data["quantity"].toString(),
                  v.data["selling_price"].toString()))
              .toString();
    }).toList();
    textMessage += "\nTotal Amount : " + widget.orderAmount.toString();
    print("textmessage $textMessage");
    // for (dynamic v in documents) {
    //   print(v.data['product_name']);
    // }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Provide Details'),
            content: TextFormField(
              controller: _dialogController,
              cursorColor: primaryColor,
              maxLength: 10,
              decoration: new InputDecoration(
                labelText: "Enter Mobile Number",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
              ),
              onChanged: (v) {},
              // onSaved: (val) => orderItem.quantity = int.tryParse(val) ?? 0,
              // validator: (val) {
              //   if (val.length == 0) {
              //     return "Quantity cannot be empty";
              //   } else {
              //     return null;
              //   }
              // },
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              textInputAction: TextInputAction.done,
              style: boldtext,
            ),
            actions: <Widget>[
              new CupertinoButton(
                child: new Text(
                  'Send',
                  style: boldtext,
                ),
                onPressed: () {
                  sendSms(orderItems);
                  Navigator.of(context).pop();
                },
              ),
              new CupertinoButton(
                child: new Text(
                  'Cancel',
                  style: boldtext,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
