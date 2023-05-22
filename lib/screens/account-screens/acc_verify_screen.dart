// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_import, library_prefixes, unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tutor_me/screens/navigation-screens/nav_dashboard_screen.dart';
import 'package:tutor_me/utilities/stream.dart';
import 'package:stream_chat/stream_chat.dart' as SC;
import '../../models/user_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    configurationStream();
    if (!isEmailVerified) {
      sendVerification();
      timer = Timer.periodic(
        Duration(seconds: 5),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future configurationStream() async {
    String userID = FirebaseAuth.instance.currentUser!.uid.toString();
    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    String userEmail = uEmail.toString();
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await docUser.get();
    Users user = Users.fromJson(snapshot.data()!);

    await CustomStream.client.connectUser(
      SC.User(
        id: userEmail.replaceAll('.', '').replaceAll('@', '-'),
        name: user.fullName,
        extraData: {'email': userEmail},
      ),
      CustomStream.client
          .devToken(userEmail.replaceAll('.', '').replaceAll('@', '-'))
          .rawValue,
    );

    final messaging = FirebaseMessaging.instance;
    String? initialToken = await messaging.getToken();
    CustomStream.client.addDevice(initialToken as String, PushProvider.firebase, pushProviderName: 'alliance');

    messaging.onTokenRefresh.listen((token) {
      CustomStream.client.addDevice(token, PushProvider.firebase);
    });
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerification() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? MainScreen()
      : Scaffold(
          appBar: AppBar(
            title: Text(
              'Verify email',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Oepn Sans', fontSize: 20),
            ),
            backgroundColor: Color.fromARGB(255, 222, 221, 221),
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: Color.fromARGB(255, 222, 221, 221),
          body: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 300,
                ),
                Container(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: const Text(
                          'A verification link has been sent to your email',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Righteous',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: const Text(
                          'Kindly check your spam folder for verification email',
                          style: TextStyle(
                            color: Color.fromARGB(255, 107, 107, 107),
                            fontFamily: 'Open Sans',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: const Text(
                          'You will be redirected to your dashboard once you have verified your email',
                          style: TextStyle(
                            color: Color(0xFF20464E),
                            fontFamily: 'Open Sans',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
}
