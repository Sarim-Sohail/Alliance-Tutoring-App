// ignore_for_file: prefer_const_constructors, unnecessary_const, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

class WelcomeScreen1 extends StatelessWidget {
  const WelcomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Image.asset(
                  'assets/images/welcome-1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'It\'s wonderful to see you\nchoose us! :\')',
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Righteous',
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/welcome-screen-2');
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
                  'Get started',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Lato',
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