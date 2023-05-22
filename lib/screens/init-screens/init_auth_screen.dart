// ignore_for_file: unused_import, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_const_constructors, unused_local_variable, prefer_const_declarations, library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat/stream_chat.dart' as SC;
import 'package:tutor_me/models/user_data_model.dart';
import 'package:tutor_me/utilities/stream.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future checkRemember(AsyncSnapshot<User?> snapshot) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _rem = (prefs.getBool('_isRemember') ?? false);

    if (_rem && snapshot.hasData) {
      
      

      Navigator.pushReplacementNamed(context, '/verify'); //verify
    } else {
      Navigator.pushReplacementNamed(context, '/login'); //login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          checkRemember(snapshot);
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
