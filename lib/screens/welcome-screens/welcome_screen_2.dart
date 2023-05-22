// ignore_for_file: prefer_const_constructors, unnecessary_const, prefer_const_literals_to_create_immutables, sort_child_properties_last, file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';

class WelcomeScreen2 extends StatelessWidget {
  const WelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 55,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Righteous',
                fontSize: 17,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.33,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Image.asset(
                  'assets/images/welcome-2.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Discover tutors\nnear you',
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lato',
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/welcome-screen-3');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF60D2E9),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.65,
                    MediaQuery.of(context).size.height * 0.05,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                        color: Color(0xFF60D2E9)),
                  ),
                ),
                child: Text(
                  'Next',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Righteous',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}