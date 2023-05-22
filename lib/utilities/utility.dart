import 'package:flutter/material.dart';

displaySnackBar(BuildContext context, String text){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content:Text(text)
    ),
  );
}