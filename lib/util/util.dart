import 'package:flutter/material.dart';
import '../main.dart';

class Util {
  static showToast(String msg) {
    final SnackBar snackBar = SnackBar(
      content: Text(
        msg,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
      backgroundColor: Colors.blue,
    );
    snackBarKey.currentState?.showSnackBar(snackBar);
  }

 static go(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
      ),
    );
  }
}
