// ignore_for_file: unused_import, prefer_const_constructors, avoid_print, avoid_function_literals_in_foreach_calls, unused_local_variable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_me/widgets/tutor_custom_cards.dart';
import '../../widgets/student_custom_cards.dart';
import '../contract-screens/contract_detail_screen.dart';

class ViewStudents extends StatefulWidget {
  const ViewStudents({Key? key}) : super(key: key);

  @override
  State<ViewStudents> createState() => _ViewStudentsState();
}

class _ViewStudentsState extends State<ViewStudents> {
  final tutors = FirebaseAuth.instance.currentUser!;
  String search = '';
  List<String> docIDs = [];

  @override
  void initState() {
    super.initState();
  }

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
        backgroundColor: Color(0xFF4ECDE6),
        elevation: 0,
        title: Text(
          'My Students',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.055,
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Color.fromARGB(134, 246, 244, 244),
                border: Border.all(
                  color: Color.fromARGB(134, 246, 244, 244),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF20464E),
                  ),
                  border: InputBorder.none,
                  hintText: 'Search for students',
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(104, 0, 0, 0),
                    fontFamily: 'Lato',
                    fontSize: 15,
                  ),
                ),
                textAlign: TextAlign.start,
                onChanged: (val) {
                  setState(() {
                    search = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contracts')
                    .where('members', arrayContains: tutors.email!)
                    .where('status', whereIn: ['inProgress', 'Completed'])
                    
                    .snapshots(),
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.waiting)) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<String> studentEmails = [];
                    var contractDocs = snapshot.data!.docs;
                    for (var contract in contractDocs) {
                      var members = contract['members'];
                      var studentEmail = members[1];
                      var status = contract['status'];
                      if (!studentEmails.contains(studentEmail)) {
                        studentEmails.add(studentEmail);
                      }
                    }

                    return ListView.builder(
                      itemCount: studentEmails.length,
                      itemBuilder: ((context, index) {
                        var email = studentEmails[index];
                        var contract = contractDocs.firstWhere(
                            (contract) => contract['members'][1] == email);
                        var data = contractDocs
                            .firstWhere(
                                (contract) => contract['members'][1] == email)
                            .data() as Map<String, dynamic>;
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if ((snapshot.connectionState ==
                                ConnectionState.waiting)) {
                              return Container();
                            } else {
                              var userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              if ((userData['fullName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(search.toLowerCase()))) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                    ),
                                    elevation: 3,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child:
                                              Image.asset('assets/Profile.png'),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    userData['fullName'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Lato',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                (contract['status'] ==
                                                        'inProgress')
                                                    ? "Contract in progress"
                                                    : "Contract completed",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Lato',
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Rs. ' +
                                                    contract['totalFee']
                                                        .toString(),
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
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: ((context) {
                                                  return ContractDetailScreen(
                                                    data: data,
                                                  );
                                                }),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF4ECDE6),
                                            minimumSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.045,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: const BorderSide(
                                                color: Color(0xFF60D2E9),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'View',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Righteous',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            }
                          },
                        );
                      }),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
