import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension hide on BuildContext {
  hideKeyBoard() {
    FocusScope.of(this).requestFocus(FocusNode());
  }
}

double getWidth(context) {
  var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  Size size = MediaQuery.of(context).size;
  if (isPortrait) {
    return size.width;
  } else {
    return size.height;
  }
}

String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('dd-MMM-hh HH:mm a');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}

double multiply(v1, v2) {
  return double.parse(v1) * double.parse(v2);
}
