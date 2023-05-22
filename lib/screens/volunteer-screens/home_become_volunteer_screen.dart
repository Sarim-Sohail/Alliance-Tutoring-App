// ignore_for_file: use_build_context_synchronously, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/tutor_data_model.dart';

class BecomeVolunteer extends StatefulWidget {
  const BecomeVolunteer({Key? key}) : super(key: key);

  @override
  State<BecomeVolunteer> createState() => _BecomeVolunteerState();
}

class _BecomeVolunteerState extends State<BecomeVolunteer> {
  bool responsibilityCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFF4ECDE6),
        title: const Text(
          'Become volunteer',
          style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 253, 253)),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(71, 216, 212, 212)),
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: Color(0xFF4ECDE6),
                        size: 30,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Volunteering to help out underprivileged students is an important part of out society. In volunteering you have to cater to whatever requirements are set by any student who requests a volunteer such as teaching specific subjects or meeting personal needs. ",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'I accept my responsibilities as a volunteer',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.grey,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return const Color(0xFF4ECDE6);
                      },
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    value: responsibilityCheck,
                    onChanged: (bool? value) async {
                      setState(() {
                        responsibilityCheck = value!;
                      });

                      if (value == true) {
                        String? userEmail =
                            FirebaseAuth.instance.currentUser?.email.toString();
                        final docTutor = FirebaseFirestore.instance
                            .collection('tutors')
                            .doc(userEmail);

                        await docTutor.update({'isVolunteer': true});
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
