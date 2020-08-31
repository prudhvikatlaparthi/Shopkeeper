import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopkeeper/add-order-item.dart';
import 'package:shopkeeper/appbar/appbar.dart';
import 'package:shopkeeper/constants/appconstants.dart';
import 'package:shopkeeper/constants/colors.dart';
import 'package:shopkeeper/constants/firebase-collections.dart';
import 'package:shopkeeper/firebase-crud.dart';
import 'package:shopkeeper/models/oders-items.dart';

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  List<OrderItem> orders = [];
  double totalAmount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        "Place Order",
        showActionButton: false,
        showBackButton: true,
        actionText: totalAmount.toString(),
      ),
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 25),
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: primaryColor,
                label: Text("Place Order  ", style: boldtext),
                onPressed: () {
                  placeOrder();
                },
              ),
            ),
            FloatingActionButton.extended(
              heroTag: null,
              backgroundColor: primaryColor,
              label: Text("Add Items", style: boldtext),
              onPressed: () {
                Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => AddOrderItem(false)))
                    .then((value) {
                  if (value != null) {
                    orders.add(value);
                    setState(() {
                      calculateTotalAmount();
                    });
                  }
                });
              },
            )
          ],
        ),
      ),
      body: Container(
        child: orders.isNotEmpty
            ? ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {},
                      child: Card(
                        color: Colors.green[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  orders[index].productCode +
                                      " - " +
                                      orders[index].productName,
                                  style: boldtext.copyWith(
                                      color: primaryColor,
                                      fontSize: 25.0,
                                      letterSpacing: 1.25),
                                ),
                                subtitle: Text(
                                  orders[index].getQuantity.toString() +
                                      " * " +
                                      orders[index].sellingPrice.toString() +
                                      " : " +
                                      (double.parse(orders[index]
                                                  .getQuantity
                                                  .toString()) *
                                              double.parse(orders[index]
                                                  .getSellingPrice
                                                  .toString()))
                                          .toString(),
                                  style: normaltext.copyWith(
                                      fontSize: 20, letterSpacing: 1.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                  ),
                                  onPressed: () {
                                    orders[index].setQuantity =
                                        orders[index].getQuantity + 1;
                                    calculateTotalAmount();
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: crossColor,
                                  ),
                                  onPressed: () {
                                    if (orders.length > 0) {
                                      if (orders[index].getQuantity > 1) {
                                        orders[index].setQuantity =
                                            orders[index].getQuantity - 1;
                                        calculateTotalAmount();
                                        setState(() {});
                                      } else {
                                        orders.removeAt(index);
                                        calculateTotalAmount();
                                        setState(() {});
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: Text(
                  "No items found\nplease add the items",
                  style: errortext,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  void placeOrder() {
    if (orders.isEmpty) {
      return;
    }
    // var _orderAmount = 0.0;
    // orders
    //     .map((e) =>
    //         _orderAmount = _orderAmount + (e.sellingPrice * e.getQuantity))
    //     .toList();
    createsubData(
        orderCollection,
        {
          orderTimeStamp: Timestamp.fromDate(DateTime.now()),
          orderAmount: totalAmount
        },
        orders);
    Navigator.pop(context, "Refresh");
  }

  void calculateTotalAmount() {
    totalAmount = 0;
    orders.map((e) {
      totalAmount = totalAmount + (e.sellingPrice * e.quantity);
    }).toList();
  }
}
