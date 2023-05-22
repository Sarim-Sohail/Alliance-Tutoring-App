// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const LoginButton({ Key? key,required this.text, required this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style:ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFE6903),
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side:const BorderSide(color: Color(0xFFFE6903))
          )
        ),
        child: Text(
          text, 
          style: const TextStyle(
            fontSize:20,
            fontFamily: 'OpenSansBold'
          )
        )
      ),
    );
  }
}