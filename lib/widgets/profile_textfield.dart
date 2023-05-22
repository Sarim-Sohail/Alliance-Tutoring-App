// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  final String text;

  const ProfileTextField({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'OpenSans',
            fontSize: 15,
          ),
          hintText: text,
        ),
      ),
    );
  }
}
