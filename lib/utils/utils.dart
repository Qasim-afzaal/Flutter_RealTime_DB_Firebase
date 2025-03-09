import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showToast(String message, {Color backgroundColor = const Color.fromARGB(255, 201, 24, 11), Color textColor = Colors.white, double fontSize = 16.0}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}