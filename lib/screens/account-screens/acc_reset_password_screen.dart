// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, unused_import, unnecessary_new, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailController = TextEditingController();

  Future resetAccount() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  'A password reset link has been sent to your email. Check your spam/junk folders.'),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  void dispose() {
    emailController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 1,
                  padding: EdgeInsets.only(right: 35, bottom: 25),
                  color: Color(0xFF4ECDE6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Recover",
                            style: TextStyle(
                              fontSize: 45,
                              fontFamily: 'Cabin',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text(
                      'Please enter your email address',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'Cabin',
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.13,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 15,
                    ),
                    controller: emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                      ),
                      hintText: 'someone@example.com',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: resetAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF60D2E9),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.6,
                      MediaQuery.of(context).size.height * 0.06,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Color(0xFF60D2E9)),
                    ),
                  ),
                  child: Text(
                    'Recover',
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Righteous',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 215),
              child: Image.asset(
                'assets/images/recover-triangles1.png',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.45,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 132),
              child: Image.asset(
                'assets/images/recover-triangles2.png',
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.45,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 5),
              child: IconButton(
                icon: Icon(
                  CupertinoIcons.back,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
