// ignore_for_file: unnecessary_new, prefer_const_constructors, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_me/utilities/stream.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: Color(0xFF4ECDE6),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/sidebar-triangles.png',
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.35,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 120),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.14,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/settings');
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lato',
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      alignment: Alignment.centerLeft,
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.7,
                        50,
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.help_outline_rounded,
                    color: Colors.black,
                  ),
                  label: Text(
                    'FAQs',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Lato',
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    alignment: Alignment.centerLeft,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      50,
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.local_police_outlined,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Terms & Policies',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Lato',
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    alignment: Alignment.centerLeft,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      50,
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    CustomStream.client.disconnectUser();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    color: Colors.black,
                  ),
                  label: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Lato',
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    alignment: Alignment.centerLeft,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      50,
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
