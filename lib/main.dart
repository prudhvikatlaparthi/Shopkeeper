import 'package:flutter/material.dart';
import 'package:shopkeeper/constants/colors.dart';
import 'package:shopkeeper/homepage.dart';
import 'package:shopkeeper/select-view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: primaryColor, primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: SelectView(),
    );
  }
}
