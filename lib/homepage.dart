import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopkeeper/add-product-item.dart';
import 'package:shopkeeper/appbar/appbar.dart';
import 'package:shopkeeper/constants/appconstants.dart';
import 'package:shopkeeper/constants/colors.dart';
import 'package:shopkeeper/constants/firebase-collections.dart';
import 'package:shopkeeper/firebase-crud.dart';

class HomePage extends StatefulWidget {
  final bool isViewMode;
  const HomePage({
    Key key,
    @required this.isViewMode,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> products;
  // Future getOrders() async {
  //   var fireStore = Firestore.instance;
  //   QuerySnapshot querySnapshot = await fireStore
  //       .collection("products")
  //       .orderBy("product_code")
  //       .getDocuments();
  //   return querySnapshot.documents;
  // }

  // fetchProducts() async {
  //   var fireStore = Firestore.instance;
  //   products =
  //       fireStore.collection("products").orderBy("product_code").snapshots();
  //   print(products);
  // }

  @override
  void initState() {
    super.initState();
    products = fetchData(productCollection, productCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        widget.isViewMode ? "Select Product" : "Shop Keeper",
        showActionButton: false,
        showBackButton: true,
      ),
      floatingActionButton: Visibility(
        visible: !widget.isViewMode,
        child: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          label: Text("Add", style: boldtext),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => AddProductItem(false))).then((value) {
              if (value != null) {
                // setState(() {});
                products = fetchData(productCollection, productCode);
              }
            });
          },
        ),
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
              child: Text(
                "No products found\nplease add the product catalogue inorder to place the order.",
                style: errortext,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        if (widget.isViewMode) {
                          Navigator.pop(
                              context, snapshot.data.documents[index]);
                        } else {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => AddProductItem(true,
                                      document: snapshot.data
                                          .documents[index]))).then((value) {
                            if (value != null) {
                              products =
                                  fetchData(productCollection, productCode);
                              // setState(() {

                              // });
                            }
                          });
                        }
                      },
                      child: Card(
                        color: Colors.green[50],
                        child: ListTile(
                          title: Text(
                            snapshot.data.documents[index]
                                    .data["product_code"] +
                                " - " +
                                snapshot
                                    .data.documents[index].data["product_name"],
                            style: boldtext.copyWith(
                                color: primaryColor,
                                fontSize: 25.0,
                                letterSpacing: 1.25),
                          ),
                          subtitle: Text(
                            "Selling price: " +
                                snapshot
                                    .data.documents[index].data["selling_price"]
                                    .toString(),
                            style: normaltext.copyWith(
                                fontSize: 20, letterSpacing: 1.5),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }
}
