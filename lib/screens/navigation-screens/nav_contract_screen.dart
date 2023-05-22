// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tutor_me/screens/contract-screens/contract_detail_screen.dart';
import 'package:tutor_me/utilities/icons.dart';

class ContractStatus extends StatefulWidget {
  const ContractStatus({super.key});

  @override
  State<ContractStatus> createState() => _ContractStatusState();
}

class _ContractStatusState extends State<ContractStatus> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool pendingContractsExpanded = true;
  bool inProgressContractsExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Contracts',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        backgroundColor: Color(0xFF4ECDE6),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/main'),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 50.h,
              width: 340.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Color(0xFF4ECDE6),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: Color(0xFF4ECDE6),
                  width: 1.5.w,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pending Contracts",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontFamily: 'Righteous',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      pendingContractsExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.white,
                      size: 30.w,
                    ),
                    padding: EdgeInsets.only(bottom: 5),
                    onPressed: (() {
                      setState(() {
                        pendingContractsExpanded = !pendingContractsExpanded;
                      });
                    }),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: pendingContractsExpanded == true,
              child: Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('contracts')
                      .where('status', isEqualTo: "Pending")
                      .where('members',
                          arrayContains: currentUser!.email.toString())
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.95,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'No pending contracts',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: 'Cabin'),
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: (pendingContractsExpanded &&
                              !inProgressContractsExpanded)
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          var data = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          var members = data['members'] as List<dynamic>;
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.22,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Card(
                              color: Colors.white,
                              elevation: 10,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Image.asset(
                                          'assets/images/profile.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.56,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['tutorName'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  data['subjects'].join(', '),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  softWrap: true,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Rs. ${data['totalFee'].toStringAsFixed(0).toString()}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 45),
                                        child: Icon(
                                          CustomIcons.icons8_help_96,
                                          color: Color(0xFF4ECDE6),
                                          size: 33,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            backgroundColor: Colors.white,
                                            title: Container(
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF4ECDE6),
                                                  border: Border.all(
                                                    color: Color(0xFF4ECDE6),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child:
                                                    Text("Contract Details")),
                                            contentTextStyle: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                            ),
                                            titleTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Righteous',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            content: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Contract Status',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(data['status']),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Tutor name',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(data[
                                                              'tutorName']),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Student name',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(data[
                                                              'studentName']),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Subjects',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(data['subjects']
                                                              .join(', ')),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Session days',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(data['days']
                                                              .join(', ')),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Number of sessions [per subject]',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(data[
                                                                  'numberOfSessions']
                                                              .toString()),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Start date',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(DateFormat(
                                                                  'EEEE, MMMM d, yyyy')
                                                              .format(DateTime
                                                                  .parse(data[
                                                                      'startDate']))),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'End date',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(DateFormat(
                                                                  'EEEE, MMMM d, yyyy')
                                                              .format(DateTime
                                                                  .parse(data[
                                                                      'endDate']))),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Total contract amount',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                              'Rs. ${data['totalFee'].toStringAsFixed(0)}'),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actionsPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            actions: [
                                              Visibility(
                                                visible: members[0] ==
                                                    currentUser!.email,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: BorderSide(
                                                        color:
                                                            Color(0xFF60D2E9),
                                                        width: 1),
                                                    backgroundColor:
                                                        Color(0xFF60D2E9),
                                                    elevation: 15,
                                                    fixedSize: Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04),
                                                  ),
                                                  onPressed: () async {
                                                    QuerySnapshot snapshot =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'contracts')
                                                            .where('contractID',
                                                                isEqualTo: data[
                                                                    'contractID'])
                                                            .get();
                                                    if (snapshot
                                                        .docs.isNotEmpty) {
                                                      DocumentReference docRef =
                                                          snapshot.docs.first
                                                              .reference;
                                                      await docRef.update({
                                                        'status': "inProgress"
                                                      });

                                                      DocumentReference
                                                          tutorRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'tutors')
                                                              .doc(data[
                                                                      'members']
                                                                  [0]);
                                                      DocumentSnapshot
                                                          tutorDataSnapshot =
                                                          await tutorRef.get();

                                                      Map<String, dynamic>
                                                          tutorData =
                                                          tutorDataSnapshot
                                                                  .data()!
                                                              as Map<String,
                                                                  dynamic>;
                                                      Map<String, dynamic>
                                                          contractedStudents =
                                                          Map.from(tutorData[
                                                                  'contractedStudents'] ??
                                                              {});
                                                      contractedStudents[
                                                              data['members']
                                                                  [1]] =
                                                          'inProgress';
                                                      await tutorRef.update({
                                                        'contractedStudents':
                                                            contractedStudents,
                                                      });
                                                      await tutorRef.update(
                                                          {'inContract': true});
                                                    }
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Contract is now in progress',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'Lato',
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                            Colors.grey,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        dismissDirection:
                                                            DismissDirection
                                                                .vertical,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                        ),
                                                        elevation: 30,
                                                        margin: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height -
                                                              180,
                                                          left: 97,
                                                          right: 97,
                                                        ),
                                                      ),
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Righteous',
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: members[0] ==
                                                    currentUser!.email,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    side: BorderSide(
                                                        color: Colors.red,
                                                        width: 1),
                                                    elevation: 10,
                                                    fixedSize: Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04),
                                                  ),
                                                  onPressed: () async {
                                                    QuerySnapshot snapshot =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'contracts')
                                                            .where('contractID',
                                                                isEqualTo: data[
                                                                    'contractID'])
                                                            .get();
                                                    if (snapshot
                                                        .docs.isNotEmpty) {
                                                      DocumentReference docRef =
                                                          snapshot.docs.first
                                                              .reference;
                                                      await docRef.delete();
                                                    }
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Contract rejected',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'Lato',
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        backgroundColor:
                                                            Colors.red.shade400,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        dismissDirection:
                                                            DismissDirection
                                                                .vertical,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                        ),
                                                        elevation: 30,
                                                        margin: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height -
                                                              180,
                                                          left: 125,
                                                          right: 125,
                                                        ),
                                                      ),
                                                    );
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'Reject',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontFamily: 'Righteous',
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: members[1] ==
                                                    currentUser!.email,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    side: BorderSide(
                                                        color:
                                                            Color(0xFF4ECDE6),
                                                        width: 1),
                                                    backgroundColor:
                                                        Color(0xFF4ECDE6),
                                                    elevation: 15,
                                                    fixedSize: Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Okay',
                                                    style: TextStyle(
                                                      color: Color(0xFF20464E),
                                                      fontFamily: 'Righteous',
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.86,
                                        MediaQuery.of(context).size.height *
                                            0.04,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      side: const BorderSide(
                                        width: 1.5,
                                        color:
                                            Color.fromARGB(255, 162, 239, 254),
                                      ),
                                    ),
                                    child: Text(
                                      'Preview',
                                      style: TextStyle(
                                        color: Color(0xFF20464E),
                                        fontFamily: 'Cabin',
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50.h,
              width: 340.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Color(0xFF4ECDE6),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: Color(0xFF4ECDE6),
                  width: 1.5.w,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ongoing Contracts",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontFamily: 'Righteous',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      inProgressContractsExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.white,
                      size: 30,
                    ),
                    padding: EdgeInsets.only(bottom: 5),
                    onPressed: (() {
                      setState(() {
                        inProgressContractsExpanded =
                            !inProgressContractsExpanded;
                      });
                    }),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: inProgressContractsExpanded == true,
              child: Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('contracts')
                      .where('status', isEqualTo: "inProgress")
                      .where('members',
                          arrayContains: currentUser!.email.toString())
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.95,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'No contracts in progress',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: 'Cabin'),
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: (inProgressContractsExpanded &&
                              !pendingContractsExpanded)
                          ? MediaQuery.of(context).size.height * 1
                          : MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          var data = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.22,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Card(
                              color: Colors.white,
                              elevation: 10,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Image.asset(
                                          'assets/images/profile.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.56,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['tutorName'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  data['subjects'].join(', '),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Rs. ${data['totalFee'].toStringAsFixed(0).toString()}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 45),
                                        child: Icon(
                                          CustomIcons
                                              .icons8_tiktok_verified_account_75,
                                          color: Color(0xFF4ECDE6),
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                      fixedSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.86,
                                        MediaQuery.of(context).size.height *
                                            0.04,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      side: const BorderSide(
                                        width: 1.5,
                                        color:
                                            Color.fromARGB(255, 162, 239, 254),
                                      ),
                                    ),
                                    child: Text(
                                      'Preview',
                                      style: TextStyle(
                                        color: Color(0xFF20464E),
                                        fontFamily: 'Cabin',
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
