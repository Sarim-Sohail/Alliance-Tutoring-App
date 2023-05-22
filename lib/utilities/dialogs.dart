// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UI {
  static void showLoading(BuildContext context, String title) {
    AlertDialog loading = AlertDialog(
        content: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
      children: [
          CircularProgressIndicator(),
          SizedBox(height: 30),
          Center(child: Text(title)),
      ],
    ),
        ));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loading;
      },
    );
  }
}
