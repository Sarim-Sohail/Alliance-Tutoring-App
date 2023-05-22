// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_me/models/tutor_data_model.dart';
import 'package:tutor_me/models/user_data_model.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/main'),
          ),
          backgroundColor: Color(0xFF4ECDE6),
          title: Text(
            'Volunteer',
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                child: GestureDetector(
                  onTap: () async {
                    String? userEmail =
                        FirebaseAuth.instance.currentUser?.email.toString();

                    final docUser = FirebaseFirestore.instance
                        .collection('users')
                        .doc(userEmail);
                    final userSnapshot = await docUser.get();
                    final userData = Users.fromJson(userSnapshot.data()!);
                    Tutors? tutorData;

                    final docTutor = FirebaseFirestore.instance
                        .collection('tutors')
                        .doc(userEmail);
                    final tutorSnapshot = await docTutor.get();
                    if (tutorSnapshot.exists) {
                      tutorData = Tutors.fromJson(tutorSnapshot.data()!);
                    }

                    // If the user is a tutor, check volunteer status
                    if (userData.isTutor) {
                      //If tutor-user is a volunteer, say that they dont need to do anything
                      if (tutorData?.isVolunteer == true) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text(
                                "You are already a volunteer!",
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontFamily: 'OpenSans',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                "Thank you for volunteering.",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontFamily: 'OpenSans',
                                  fontSize: 17,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Color(0xFF60D2E9)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      fontFamily: 'Righteous',
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } //If tutor-user isnt a volunteer, make them a volunteer if they want to
                      else {
                        bool confirmed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text(
                                "Become a volunteer",
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontFamily: 'OpenSans',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                "Since you're a tutor, you can now sign up to become a volunteer too!",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontFamily: 'OpenSans',
                                  fontSize: 17,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: Color(0xFF60D2E9)),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontFamily: 'Righteous',
                                        color: Color(0xFF60D2E9)),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Color(0xFF60D2E9)),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontFamily: 'Righteous',
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed) {
                          await Navigator.pushNamed(
                              context, '/become-volunteer-screen');
                        }
                      }
                    } //If user isn't a tutor, tell them to become a tutor first before becoming a volunteer
                    else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              "Alert",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontFamily: 'OpenSans',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              "You must first become a tutor before becoming a volunteer. Click sign up to register as a tutor.",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontFamily: 'OpenSans',
                                fontSize: 17,
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color: Color(0xFF60D2E9)),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontFamily: 'Righteous',
                                      color: Color(0xFF60D2E9)),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Color(0xFF60D2E9)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushNamed(context, '/become-tutor');
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontFamily: 'Righteous',
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    decoration: BoxDecoration(
                      color: Color(0xFF4ECDE6),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFF4ECDE6),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Become a Volunteer',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.12,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: Image.asset(
                            'assets/images/become-a-volunteer.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.92,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/request-volunteer-screen');
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    decoration: BoxDecoration(
                      color: Color(0xFF3EA4B8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFF3EA4B8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: Image.asset(
                            'assets/images/ask-volunteer.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.13,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Request a Volunteer',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
