// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      checkFirstSeen();
    });
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).popAndPushNamed('/auth-screen'); //auth
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacementNamed('/welcome-screen-1'); //login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF60D2E9),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
              ),
              Image.asset(
                'assets/logo.png',
                height: 140,
                width: 140,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
              ),
              Text(
                'Alliance',
                style: TextStyle(color: Colors.white,fontSize: 45, fontFamily: 'Righteous'),
              ),
              
              Text(
                'SEEK & CHOOSE',
                style: TextStyle(
                    fontSize: 27,
                    fontFamily: 'CormorantGaramond',
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
