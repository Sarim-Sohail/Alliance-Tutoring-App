// ignore_for_file: prefer_const_constructors, sort_child_properties_last, library_private_types_in_public_api, unused_import, unnecessary_null_comparison, prefer_final_fields, unused_element, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_me/models/firebase_model.dart';
import 'package:tutor_me/screens/old-screens/conv_message_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_contract_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_student_home_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_meeting_screen.dart';
import 'package:tutor_me/screens/old-screens/nav_conversation_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_session_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_tutor_home_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_volunteer_screen.dart';
import 'package:tutor_me/utilities/stream.dart';
import 'package:tutor_me/widgets/navigator_widget.dart';

import '../../models/user_chat_model.dart';
import 'nav_conversation_screen.dart';
// import '../resources/custom_icons_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserModel _userModel = UserModel();
  User _currentUser = FirebaseAuth.instance.currentUser!;
  late Future<bool> _isTutorFuture;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _isTutorFuture = _fetchIsTutor();
    
  }

  Future<bool> _fetchIsTutor() async {
    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    late String userEmail = uEmail.toString();
    late final docUser =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final value = await docUser.get();
    
    return value.data()!['isTutor'];
  }


  changePage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  Future<void> _fetchUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    UserModel? userModel =
        await FirebaseHelper.getUserData(currentUser!.email.toString());
    if (userModel != null) {
      setState(() {
        _userModel = userModel;
        _currentUser = currentUser;
      });
    }
  }

  List<Widget> get pageList {
    List<Widget> pages = [
      const ContractStatus(),
      const VolunteerScreen(),
      const MeetingScreen(),
    ];
    pages.add(ChannelListPage(client: CustomStream.client),);

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<bool>(
        future: _isTutorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data.'),
            );
          } else {
            final isTutor = snapshot.data!;
            final dashboardPage =
                isTutor ? TutorDashboard() : StudentDashboard();
            final pages = pageList;
            pages.insert(0,dashboardPage);
            
            return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  pages[pageIndex],
                ],
              ),
              
            );
          }
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
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