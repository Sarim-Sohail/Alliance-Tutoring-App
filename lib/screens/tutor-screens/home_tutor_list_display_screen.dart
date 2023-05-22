// ignore_for_file: unused_import, prefer_const_constructors, avoid_print, avoid_function_literals_in_foreach_calls, unused_local_variable, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:tutor_me/models/firebase_model.dart';
import 'package:tutor_me/models/user_chat_model.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_view_detail_screen.dart';
import 'package:tutor_me/widgets/tutor_custom_cards.dart';

class ViewTutors extends StatefulWidget {
  const ViewTutors({Key? key}) : super(key: key);

  @override
  State<ViewTutors> createState() => _ViewTutorsState();
}

class _ViewTutorsState extends State<ViewTutors> {
  final storage = FlutterSecureStorage();
  final tutors = FirebaseAuth.instance.currentUser!;
  String search = '';

  Map<String, dynamic> filters = {};

  bool? verifiedFilter;
  bool isFilter = false;
  String? genderFilter;
  String? addressFilter;
  String? qualificationFilter;
  String? modeFilter;

  List<String> docIDs = [];
  List<String> randomizedDocIds = [];

  UserModel _userModel = UserModel();
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _fetchUser() async {
    if (mounted) {
      UserModel? userModel =
          await FirebaseHelper.getUserData(currentUser!.email.toString());
      if (userModel != null) {
        setState(() {
          _userModel = userModel;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFF4ECDE6),
        title: Text(
          'Tutor List',
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
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.055,
                  margin: EdgeInsets.only(left: 15),
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
                      hintText: 'Search for tutors by name or area',
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
                IconButton(
                  onPressed: () async {
                    Map<String, dynamic>? updatedFilters =
                        await Navigator.pushNamed(
                      context,
                      '/view-tutors-filters-screen',
                    ) as Map<String, dynamic>?;

                    setState(() {
                      if (updatedFilters != null) {
                        filters = updatedFilters;

                        verifiedFilter = filters['verified'];
                        genderFilter = filters['gender'];
                        qualificationFilter = filters['qualification'];
                        modeFilter = filters['mode'];
                        addressFilter = filters['address'];
                        isFilter = filters['isFilter'];

                        print('Gender Filter: $genderFilter');
                        print('Qualification Filter: $qualificationFilter');
                        print('Mode Filter: $modeFilter');
                        print('Address Filter: $addressFilter');
                        print('Verified Filter: $verifiedFilter');
                        print('Filter: $isFilter');
                      }
                    });
                  },
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: Color(0xFF20464E),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tutors')
                    .where('email', isNotEqualTo: currentUser!.email.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final docs = snapshot.data!.docs;
                    List<Map<String, dynamic>> filteredDocs = docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();

                    if (search.isNotEmpty) {
                      filteredDocs = docs
                          .where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final fullName =
                                data['fullName'].toString().toLowerCase();
                            final address =
                                data['address'].toString().toLowerCase();
                            return fullName.contains(search.toLowerCase()) ||
                                address.contains(search.toLowerCase());
                          })
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();
                    }
                    if (isFilter) {
                      filteredDocs = filteredDocs.where((data) {
                        bool filterCondition = true;
                        if (filters['verified'] != null) {
                          filterCondition &=
                              (data['isVerified'] == filters['verified']);
                        }
                        if (filters['gender'] != null) {
                          filterCondition &=
                              (data['gender'] == filters['gender']);
                        }
                        if (filters['address'] != null) {
                          filterCondition &=
                              (data['address'] == filters['address']);
                        }
                        if (filters['qualification'] != null) {
                          filterCondition &= (data['qualification'] ==
                              filters['qualification']);
                        }
                        if (filters['mode'] != null) {
                          filterCondition &=
                              (data['tutoringMode'] == filters['mode']);
                        }
                        return filterCondition;
                      }).toList();
                    }

                    if (filteredDocs.isEmpty) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Image.asset(
                              'assets/images/no-results.png',
                              fit: BoxFit.contain,
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: ((context, index) {
                          var data = filteredDocs[index];

                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              elevation: 3,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Image.asset('assets/Profile.png'),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
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
                                            Row(
                                              children: [
                                                Text(
                                                  data['fullName'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  softWrap: true,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 2,
                                                ),
                                                data['isVerified'] == true
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        child: Icon(
                                                            Icons.verified,
                                                            color: Color(
                                                                0xFF4ECDE6),
                                                            size: 20))
                                                    : Text('')
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          data['address'] +
                                              "\n" +
                                              data['tutoringMode'],
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
                                          builder: (context) {
                                            return TutorDetail(
                                              tutorEmail: data['email'],
                                              userModel: _userModel,
                                              firebaseUser: currentUser,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF60D2E9),
                                      minimumSize: Size(
                                        MediaQuery.of(context).size.width * 0.2,
                                        MediaQuery.of(context).size.height *
                                            0.045,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
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
                        }),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
