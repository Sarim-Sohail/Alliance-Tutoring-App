// ignore_for_file: prefer_const_constructors, sort_child_properties_last, library_private_types_in_public_api, unused_import, unnecessary_null_comparison, prefer_final_fields, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_me/models/firebase_model.dart';
import 'package:tutor_me/screens/student-screens/home_student_profile_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_profile_screen.dart';
import 'package:tutor_me/screens/old-screens/conv_message_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_contract_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_student_home_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_meeting_screen.dart';
import 'package:tutor_me/screens/old-screens/nav_conversation_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_session_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_tutor_home_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_volunteer_screen.dart';

import 'package:tutor_me/widgets/navigator_widget.dart';

import '../../../models/user_chat_model.dart';
import '../../utilities/icons.dart';
// import '../resources/custom_icons_icons.dart';

class ProfileNavScreen extends StatefulWidget {
  const ProfileNavScreen({Key? key}) : super(key: key);

  @override
  _ProfileNavScreenState createState() => _ProfileNavScreenState();
}

class _ProfileNavScreenState extends State<ProfileNavScreen> {
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  changePage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  List<Widget> pages = [
    const ProfileScreen(),
    const TutorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: pages.elementAt(pageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5F5F5),
        selectedItemColor: const Color.fromARGB(255, 48, 141, 160),
        unselectedItemColor: const Color(0xFF20464E),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        elevation: 20,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              CustomIcons.icons8_user_96,
              size: 29,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CustomIcons.icons8_student_male_96,
              size: 29,
            ),
            label: '',
          ),
        ],
        currentIndex: pageIndex,
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
        },
      ),
    );
  }
}
