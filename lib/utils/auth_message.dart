import 'package:flutter/material.dart';
import 'package:waste_application/theme.dart';

class AuthMessage {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 500),
        content: Text(text),
        backgroundColor: Colors.red);

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

class AuthMessageOTP {
  static final messengerKeyOTP = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, double pos) {
    if (text == null) return;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(top: pos),
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      backgroundColor: alertColor,
    );

    messengerKeyOTP.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
