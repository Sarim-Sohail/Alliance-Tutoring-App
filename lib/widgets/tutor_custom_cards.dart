// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, unused_import

import 'package:flutter/material.dart';

class TutorCustomCards extends StatelessWidget {
  const TutorCustomCards({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.trailing,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String leading;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Card(
        color: Color.fromARGB(255, 247, 244, 244),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        child: Row(
          children: [
            SizedBox(
              child: Image.asset('assets/Profile.png'),
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Lato',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tutor-detail',
                    arguments: {'tutorDoc': trailing});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 162, 239, 254),
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.15,
                  MediaQuery.of(context).size.height * 0.05,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 162, 239, 254),
                  ),
                ),
              ),
              child: Text(
                'VIEW',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Righteous',
                  color: Color(0xFF20464E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
