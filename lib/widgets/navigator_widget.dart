// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tutor_me/utilities/icons.dart';
// import 'package:tutor_me/screens/nav_home_screen.dart';
// import 'package:tutor_me/screens/nav_meeting_screen.dart';
// import 'package:tutor_me/screens/nav_conversation_screen.dart';
// import 'package:tutor_me/screens/nav_session_screen.dart';
// import 'package:tutor_me/screens/nav_volunteer_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const MyBottomNavigationBar({super.key, 
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF5F5F5),
      selectedItemColor: const Color(0xFF4EcDE6),
      unselectedItemColor: const Color(0xFF20464E),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            CustomIcons.icons8_home_96,
            size: 27,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            CustomIcons.icons8_terms_and_conditions_96,
            size: 27,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            CustomIcons.icons8_welfare_31,
            size: 27,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            CustomIcons.icons8_video_conference_31,
            size: 30,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            CustomIcons.icons8_group_message_31,
            size: 30,
          ),
          label: '',
        ),
      ],
    );
  }
}
