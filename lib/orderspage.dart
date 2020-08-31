import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopkeeper/constants/common-utils.dart';
import 'package:shopkeeper/order-details.dart';
import 'package:shopkeeper/place-order.dart';
import 'package:shopkeeper/appbar/appbar.dart';
import 'package:shopkeeper/constants/appconstants.dart';
import 'package:shopkeeper/constants/colors.dart';
import 'package:shopkeeper/constants/firebase-collections.dart';
import 'package:shopkeeper/firebase-crud.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Stream<QuerySnapshot> products;
  @override
  void initState() {
    super.initState();
    products = fetchData(orderCollection, orderTimeStamp, isDescending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("Orders", showBackButton: true, showActionButton: false),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        label: Text("Add", style: boldtext),
        onPressed: () {
          Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => PlaceOrder()))
              .then((value) {
            if (value != null) {
              setState(() {});
            }
          });
        },
      ),
      body:
          Container(color: Colors.white.withOpacity(0.7), child: getProducts()),
    );
  }

  Widget getProducts() {
    // if(products == null){
    //   return
    // }
    return StreamBuilder<QuerySnapshot>(
        stream: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading", style: normaltext),
            );
          } else if (snapshot.data.documents.length == 0) {
            return Center(
              child: Text("No orders found.", style: errortext),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => OrderDetails(
                                    snapshot.data.documents[index].documentID,
                                    DateFormat('dd-MMM-hh HH:mm a').format(
                                        snapshot.data.documents[index]
                                            .data[orderTimeStamp]
                                            .toDate()),
                                    snapshot.data.documents[index]
                                            .data[orderAmount]
                                            .toString() ??
                                        "0")));
                      },
                      child: Card(
                        color: Colors.green[50],
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.red,
                            child: Text(
                              (snapshot.data.documents[index].data[orderAmount]
                                      .toString() ??
                                  "0"),
                              style: normaltext.copyWith(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            "OrderID: " +
                                snapshot.data.documents[index].documentID
                                    .substring(0, 8),
                            style: boldtext.copyWith(
                                color: primaryColor, letterSpacing: 1.25),
                          ),
                          subtitle: Text(
                            getDate(snapshot.data.documents[index]),
                            style: normaltext.copyWith(letterSpacing: 1.5),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }

  String getDate(DocumentSnapshot document) {
    Timestamp timestamp = document.data[orderTimeStamp];
    return readTimestamp(timestamp.toDate().millisecondsSinceEpoch);
  }
}
