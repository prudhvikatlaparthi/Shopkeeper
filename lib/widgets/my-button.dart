import 'package:flutter/material.dart';
import 'package:shopkeeper/constants/colors.dart';

class MyButton extends StatelessWidget {
  final Function onButtonClick;
  final String buttonName;

  const MyButton(
      {Key key, @required this.onButtonClick, @required this.buttonName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 50.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: primaryColor,
        color: deleteColor,
        elevation: 7.0,
        child: InkWell(
          onTap: onButtonClick,
          child: Center(
            child: Text(
              buttonName,
              style: TextStyle(
                  fontFamily: 'bold',
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
