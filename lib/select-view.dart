import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopkeeper/appbar/appbar.dart';
import 'package:shopkeeper/constants/appconstants.dart';
import 'package:shopkeeper/constants/colors.dart';
import 'package:shopkeeper/homepage.dart';
import 'package:shopkeeper/orderspage.dart';
import 'package:shopkeeper/widgets/separator.dart';

class SelectView extends StatefulWidget {
  @override
  _SelectViewState createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  bool isFirstSelected = false;

  bool isSecondSelected = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: MyAppBar(
          "Select View",
          showBackButton: false,
          showActionButton: false,
        ),
        body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: size.height / 3,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: CupertinoButton(
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return HomePage(
                              isViewMode: false,
                            );
                          }));
                        },
                        child: Text(
                          "Manage Product Catalogue",
                          style: boldtext.copyWith(
                            color: primaryColor,
                            fontSize: 40.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      height: size.height / 3,
                      child: CupertinoButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => OrdersPage()));
                        },
                        child: Text(
                          "Manage Orders",
                          style: boldtext.copyWith(
                            color: primaryColor,
                            fontSize: 40.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ],
              )),
        ));
  }
}
