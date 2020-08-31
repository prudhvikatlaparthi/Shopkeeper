import 'package:flutter/material.dart';
import 'package:shopkeeper/constants/appconstants.dart';
import 'package:shopkeeper/constants/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  Function actionTapped;
  bool showBackButton;
  bool showActionButton;
  String actionText;

  MyAppBar(this.title,
      {Key key,
      @required this.showBackButton,
      @required this.showActionButton,
      this.actionTapped,
      this.actionText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: whiteColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      title: Text(
        title,
        style: boldtext.copyWith(color: whiteColor),
      ),
      actions: <Widget>[
        showActionButton
            ? IconButton(
                icon: Icon(
                  Icons.done,
                  color: whiteColor,
                ),
                onPressed: actionTapped,
              )
            : actionText != null
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      actionText,
                      style: boldtext.copyWith(
                        color: whiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container(),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
