// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_this, sized_box_for_whitespace, sort_child_properties_last, avoid_print, unused_local_variable, unrelated_type_equality_checks, unused_field, prefer_final_fields, unused_import, use_build_context_synchronously, unnecessary_null_comparison, library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as SCC;
import 'package:tutor_me/models/firebase_model.dart';
import 'package:tutor_me/models/user_chat_model.dart';
import 'package:tutor_me/screens/old-screens/conv_message_screen.dart';
import 'package:tutor_me/screens/old-screens/nav_conversation_screen.dart';
import 'package:tutor_me/models/room_model.dart';
import 'package:uuid/uuid.dart';
import 'package:stream_chat/stream_chat.dart' as SC;
// import 'package:tutor_me/utilities/info.dart';
import '../../models/user_data_model.dart';
import '../../utilities/icons.dart';
import 'package:tutor_me/utilities/stream.dart';
import 'package:tutor_me/screens/navigation-screens/nav_conversation_screen.dart';

var uuid = Uuid();

class TutorDetail extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;
  final String? tutorEmail;
  const TutorDetail(
      {super.key, this.userModel, this.firebaseUser, this.tutorEmail});

  @override
  State<TutorDetail> createState() => _TutorDetailState();
}

class _TutorDetailState extends State<TutorDetail> {
  bool? isPersonalDetail = false;
  bool? isTutionDetail = true;
  bool? isEmployed = false;

  String _fullName = '';
  String _dateOfBirth = '';
  String _email = '';
  String _address = '';
  String _gender = '';
  String _qualification = '';
  String _degreeNumber = '';
  String _tutoringMode = '';
  String _currentEmployment = '';
  int _yearsOfExperience = 0;
  int _noOfReviews = 0;
  double _rating = 0.0;
  bool _isVerified = false;
  Map<String, double> _prices = {};
  Map<String, dynamic> _timings = {};
  UserModel _targetModel = UserModel();
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    retrieveUserData(widget.tutorEmail.toString());
  }

  Future<void> retrieveUserData(String parameter) async {
    UserModel? targetModel = await FirebaseHelper.getUserData(parameter);
    if (targetModel != null) {
      setState(() {
        _targetModel = targetModel;
      });
    }

    DateTime now = DateTime.now();
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('tutors')
          .doc(parameter)
          .get();
      if (documentSnapshot.exists) {
        setState(() {
          _userData = documentSnapshot.data() as Map<String, dynamic>;

          final DateTime birthDate =
              DateTime.parse(documentSnapshot.get('dateOfBirth'));
          final int ageInYears =
              DateTime.now().difference(birthDate).inDays ~/ 365;

          final Map<String, dynamic> subjectsMap =
              documentSnapshot.get('prices');
          final List<String> listSubjects = subjectsMap.keys.toList();
          final List<double> listSubjectPrices = subjectsMap.values
              .map<double>((value) => value.toDouble())
              .toList();

          final Map<String, double> mapPrices =
              Map.fromIterables(listSubjects, listSubjectPrices);

          final Map<String, dynamic> timingsMap =
              documentSnapshot.get('timings');
          final List<dynamic> listSubjectTimings = timingsMap.values.toList();
          final Map<String, String> mapTimings = {};

          for (int i = 0; i < listSubjects.length; i++) {
            String subject = listSubjects[i];
            dynamic timing = listSubjectTimings[i];
            if (timing != null) {
              mapTimings[subject] = timing.toString();
            }
          }

          _email = documentSnapshot.get('email');
          _fullName = documentSnapshot.get('fullName');
          _gender = documentSnapshot.get('gender');
          _dateOfBirth = '$ageInYears years old';
          _address = documentSnapshot.get('address');
          _noOfReviews = documentSnapshot.get('numberOfReviews');
          _prices = mapPrices;
          _timings = mapTimings;
          _tutoringMode = documentSnapshot.get('tutoringMode');
          _yearsOfExperience = documentSnapshot.get('yearsOfExperience');
          _qualification = documentSnapshot.get('qualification');
          _currentEmployment = documentSnapshot.get('currentEmployment');
          _isVerified = documentSnapshot.get('isVerified');
          _rating = documentSnapshot.get('rating').toDouble();
          if (_rating == 0 || _rating == 0.0) {
            _rating = 0.0;
          }
        });
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error retrieving user data: ');
      print(e);
    }
  }

  Future<void> addEmail(String email) async {
    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    String userEmail = uEmail.toString();

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    List<dynamic> conversations =
        (userDoc.data() as Map<String, dynamic>)['conversations'];
    if (conversations.contains(email)) {
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
      'conversations': FieldValue.arrayUnion([email])
    });

    // print('$email added to the conversations array');
  }

  Future<RoomModel?> getRoomModel(String targetEmail) async {
    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    String userEmail = uEmail.toString();

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("chats").get();

    RoomModel? roomModel;
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data["participants"][userEmail] == true &&
          data["participants"][targetEmail] == true) {
        roomModel = RoomModel.fromMap(data);
        break;
      }
    }

    if (roomModel == null) {
      // room not found
      // print("bruh");
      RoomModel newRoomModel = RoomModel(
          roomID: uuid.v1(),
          lastMessage: "",
          participants: {userEmail: true, targetEmail: true},
          lastMessageSent: DateTime.now(),
          members: [userEmail.toString(), targetEmail.toString()]);

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(newRoomModel.roomID)
          .set(newRoomModel.toMap());
      roomModel = newRoomModel;
      return roomModel;
    } else {
      //room found
      // print("test");
      // var docData = snapshot.docs[0].data();
      // RoomModel oldRoomModel =
      //     RoomModel.fromMap(docData as Map<String, dynamic>);
      // roomModel = oldRoomModel;
      return roomModel;
    }
  }

  // Future<RoomModel?> getRoomModel(String targetEmail) async {
  //   RoomModel roomModel;
  //   String? uEmail = FirebaseAuth.instance.currentUser?.email;
  //   String userEmail = uEmail.toString();
  //   print(userEmail);
  //   print(targetEmail);

  //   QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection("chats")
  //       .where("participants.{$userEmail.toString()}", isEqualTo: true)
  //       .where("participants.{$targetEmail.toString()}", isEqualTo: true)
  //       .get();

  //   if (snapshot.docs.isNotEmpty) {
  //     print("test");
  //     var docData = snapshot.docs[0].data();
  //     RoomModel oldRoomModel =
  //         RoomModel.fromMap(docData as Map<String, dynamic>);
  //     roomModel = oldRoomModel;
  //   } else {
  //     print("bruh");
  //     RoomModel newRoomModel =
  //         RoomModel(roomID: uuid.v1(), lastMessage: "", participants: {
  //       userEmail.toString(): true,
  //       targetEmail.toString(): true,
  //     });

  //     await FirebaseFirestore.instance
  //         .collection('chats')
  //         .doc(newRoomModel.roomID)
  //         .set(newRoomModel.toMap());
  //     roomModel = newRoomModel;
  //   }
  //   return roomModel;
  // }

  // Future<double> getRating(String documentID) async {
  //   final tutor =
  //       FirebaseFirestore.instance.collection('tutors').doc(documentID);
  //   final snapshot = await tutor.get();
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   final ratings = (data['Rating']).toDouble();
  //   return ratings;
  // }

  Future<String> getUidFromEmail(String email) async {
    String uid = '';

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: 'dummy-password', // Provide a dummy password
      );

      uid = userCredential.user!.uid;

      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error getting UID from email: $e');
    }
    print(uid);
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 30),
            onPressed: () async {
              RoomModel? room = await getRoomModel(_email);
              await addEmail(_email);

              final channel = CustomStream.client.channel(
                "messaging",
                id: room!.roomID as String,
              );
              await channel.create();
              await channel.watch();

              final uID = FirebaseAuth.instance.currentUser!.email;
              final tID = _email;
              print(room.roomID);
              print("user ID $uID");
              print("tutor ID $tID");

              await channel.addMembers([
                uID.toString().replaceAll('.', '').replaceAll('@', '-'),
                tID.replaceAll('.', '').replaceAll('@', '-')
              ]);

              if (room != null) {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChannelListPage(client: CustomStream.client)),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MessageScreen(
                //       firebaseUser: widget.firebaseUser as User,
                //       roomModel: room,
                //       targetUser: _targetModel,
                //       userModel: widget.userModel as UserModel,
                //     ),
                //   ),
                // );
              }
            },
            icon: Icon(
              CustomIcons.icons8_mailing_96,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.31,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFF4ECDE6),
                        Color.fromARGB(255, 29, 57, 63),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width * 0.93,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(
                              0.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),

                          //User Name Display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _fullName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              _isVerified
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Icon(Icons.verified,
                                          color: Color(0xFF4ECDE6), size: 20))
                                  : Text('')
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //Tution View, Personal View Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (this.isPersonalDetail == false &&
                                  this.isTutionDetail == true)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.4,
                                      MediaQuery.of(context).size.height *
                                          0.125,
                                    ),
                                    padding: EdgeInsets.only(left: 5),
                                    backgroundColor: Color(0xFF4ECDE6),
                                    alignment: Alignment.center,
                                    shadowColor: Colors.grey,
                                    elevation: 10,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      this.isTutionDetail = true;
                                      this.isPersonalDetail = false;
                                      _currentEmployment == ""
                                          ? isEmployed = false
                                          : isEmployed = true;
                                    });
                                  },
                                  icon: Icon(
                                    CustomIcons.icons8_graduation_cap_31,
                                    color: Colors.white,
                                    size: 55,
                                  ),
                                  label: Text(''),
                                )
                              else
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.4,
                                      MediaQuery.of(context).size.height *
                                          0.125,
                                    ),
                                    padding: EdgeInsets.only(left: 5),
                                    backgroundColor: Color(0xFF4ECDE6),
                                    alignment: Alignment.center,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      this.isTutionDetail = true;
                                      this.isPersonalDetail = false;
                                    });
                                  },
                                  icon: Icon(
                                    CustomIcons.icons8_graduation_cap_31,
                                    color: Colors.white,
                                    size: 55,
                                  ),
                                  label: Text(''),
                                ),
                              SizedBox(
                                width: 10,
                              ),
                              if (this.isPersonalDetail == true &&
                                  this.isTutionDetail == false)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.4,
                                      MediaQuery.of(context).size.height *
                                          0.125,
                                    ),
                                    padding: EdgeInsets.only(left: 5),
                                    backgroundColor: Color(0xFF4ECDE6),
                                    shadowColor: Colors.grey,
                                    elevation: 10,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      this.isTutionDetail = false;
                                      this.isPersonalDetail = true;
                                    });
                                  },
                                  icon: Icon(
                                    CustomIcons.icons8_person_96,
                                    color: Colors.white,
                                    size: 55,
                                  ),
                                  label: Text(''),
                                )
                              else
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.4,
                                      MediaQuery.of(context).size.height *
                                          0.125,
                                    ),
                                    padding: EdgeInsets.only(left: 5),
                                    backgroundColor: Color(0xFF4ECDE6),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      this.isTutionDetail = false;
                                      this.isPersonalDetail = true;
                                    });
                                  },
                                  icon: Icon(
                                    CustomIcons.icons8_person_96,
                                    color: Colors.white,
                                    size: 55,
                                  ),
                                  label: Text(''),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //Tutor Subjects Display OR Tutor Gender Display
                          Row(
                            children: [
                              SizedBox(
                                width: 35,
                              ),
                              if (this.isTutionDetail == true &&
                                  this.isPersonalDetail == false)
                                Text(
                                  'Subjects',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else
                                Text(
                                  'Gender',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              if (this.isPersonalDetail == true &&
                                  this.isTutionDetail == false)
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                )
                              else
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                              if (this.isPersonalDetail == true &&
                                  this.isTutionDetail == false)
                                Text(
                                  _gender,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                    fontSize: 17,
                                  ),
                                )
                              else
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Table(
                                    // border: TableBorder.symmetric(
                                    //   outside: BorderSide(
                                    //       width: 0.5, color: Colors.grey),
                                    // ),
                                    // border: TableBorder(
                                    //   left: BorderSide(
                                    //     width: 0.5,
                                    //     color: Colors.grey,
                                    //   ),
                                    //   right: BorderSide(
                                    //     width: 0.5,
                                    //     color: Colors.grey,
                                    //   ),
                                    //   top: BorderSide(
                                    //     width: 0.5,
                                    //     color: Colors.grey,
                                    //   ),
                                    //   bottom: BorderSide(
                                    //     width: 0.5,
                                    //     color: Colors.grey,
                                    //   ),
                                    //   horizontalInside: BorderSide(
                                    //     width: 0.5,
                                    //     color: Colors.grey,
                                    //   ),
                                    //   borderRadius: BorderRadius.all(
                                    //     Radius.circular(10),
                                    //   ),
                                    // ),
                                    columnWidths: const {
                                      0: FlexColumnWidth(3.5),
                                      1: FlexColumnWidth(3),
                                      2: FlexColumnWidth(4),
                                    },
                                    children: [
                                      for (var subject in _prices.keys)
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.5, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15.0),
                                              child: Text(
                                                subject.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15.0),
                                              child: Text(
                                                'Rs. ${_prices[subject].toString()}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15.0),
                                              child: Text(
                                                _timings[subject].toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //Tutor Teaching Mode Display OR Age Display
                          Row(
                            children: [
                              SizedBox(
                                width: 35,
                              ),
                              if (this.isPersonalDetail == true &&
                                  this.isTutionDetail == false)
                                Text(
                                  'Age',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else
                                Text(
                                  'Teaching Mode',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.12,
                              ),
                              if (this.isPersonalDetail == true &&
                                  this.isTutionDetail == false)
                                Text(
                                  _dateOfBirth,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                    fontSize: 17,
                                  ),
                                )
                              else
                                Text(
                                  _tutoringMode,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                    fontSize: 17,
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //Display tutor qualification
                          Row(
                            children: [
                              SizedBox(
                                width: 35,
                              ),
                              if (this.isPersonalDetail == false &&
                                  this.isTutionDetail == true)
                                Text(
                                  'Qualification',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ],
                          ),
                          if (this.isPersonalDetail == false &&
                              this.isTutionDetail == true)
                            SizedBox(
                              height: 5,
                            ),
                          if (this.isPersonalDetail == false &&
                              this.isTutionDetail == true)
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                ),
                                if (this.isPersonalDetail == false &&
                                    this.isTutionDetail == true)
                                  Text(
                                    _qualification,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Lato',
                                      fontSize: 17,
                                    ),
                                  )
                              ],
                            ),
                          if (this.isPersonalDetail == false &&
                              this.isTutionDetail == true)
                            SizedBox(
                              height: 20,
                            ),

                          //Display tutor years of experience
                          if (this.isPersonalDetail == false &&
                              this.isTutionDetail == true)
                            Row(
                              children: [
                                SizedBox(
                                  width: 35,
                                ),
                                if (this.isPersonalDetail == false &&
                                    this.isTutionDetail == true)
                                  Text(
                                    'Years of Experience',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ],
                            ),
                          if (this.isPersonalDetail == false &&
                              this.isTutionDetail == true)
                            SizedBox(
                              height: 5,
                            ),
                          if (this.isPersonalDetail == false &&
                              this.isTutionDetail == true)
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                ),
                                if (this.isPersonalDetail == false &&
                                    this.isTutionDetail == true)
                                  Text(
                                    _yearsOfExperience.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Lato',
                                      fontSize: 17,
                                    ),
                                  )
                              ],
                            ),

                          //Tutor Fees Display OR Location Display
                          Row(
                            children: [
                              SizedBox(
                                width: 35,
                              ),
                              if (this.isPersonalDetail == true &&
                                  this.isTutionDetail == false)
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          if (this.isPersonalDetail == true &&
                              this.isTutionDetail == false)
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                ),
                                Text(
                                  _address,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),

                          //Current Employment
                          if (this.isPersonalDetail == true &&
                              this.isTutionDetail == false)
                            Visibility(
                              visible: _currentEmployment != "" &&
                                  _currentEmployment.isNotEmpty,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.09),
                                      Text(
                                        "Current Employment",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Lato',
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12),
                                      Text(
                                        _currentEmployment,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Lato',
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          //Tutor Rating & Reviews Display
                          if (this.isPersonalDetail == false &&
                              this.isTutionDetail == true)
                            Row(
                              children: [
                                SizedBox(
                                  width: 35,
                                ),
                                Text(
                                  'Ratings',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '($_noOfReviews)',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (this.isPersonalDetail == false &&
                              this.isTutionDetail == true)
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                ),
                                RatingBar(
                                  ignoreGestures: true,
                                  initialRating: _rating,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  updateOnDrag: false,
                                  tapOnlyMode: true,
                                  glow: false,
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                      full: const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 10,
                                      ),
                                      half: const Icon(
                                        Icons.star_half,
                                        color: Colors.yellow,
                                        size: 10,
                                      ),
                                      empty: const Icon(
                                        Icons.star_outline,
                                        color: Colors.yellow,
                                        size: 10,
                                      )),
                                  onRatingUpdate: (value) {},
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/user-image.png',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
