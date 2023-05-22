// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_contains

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

import '../../models/firebase_model.dart';
import '../../models/user_chat_model.dart';
import '../../utilities/icons.dart';

class ViewVolunteerRequestsScreen extends StatefulWidget {
  const ViewVolunteerRequestsScreen({super.key});

  @override
  State<ViewVolunteerRequestsScreen> createState() =>
      _ViewVolunteerRequestsScreenState();
}

class _ViewVolunteerRequestsScreenState
    extends State<ViewVolunteerRequestsScreen> {
  final tutors = FirebaseAuth.instance.currentUser!;
  String search = '';

  int? getDayOfWeek(String day) {
    final dayzOfWeek = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
    };
    return dayzOfWeek[day];
  }

  Map<String, dynamic> filters = {};

  String? daysOfWeekFilter;
  bool isFilter = false;
  String? subjectsFilter;
  int? numberOfSessionsFilter;
  int? maximumTotalFeeFilter;

  List<String> docIDs = [];
  List<String> randomizedDocIds = [];

  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _fetchUser() async {
    if (mounted) {
      UserModel? userModel =
          await FirebaseHelper.getUserData(currentUser!.email.toString());
      if (userModel != null) {
        setState(() {});
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
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFF4ECDE6),
        title: const Text(
          'Volunteering requests list',
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.055,
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(134, 246, 244, 244),
                    border: Border.all(
                      color: const Color.fromARGB(134, 246, 244, 244),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF20464E),
                      ),
                      border: InputBorder.none,
                      hintText: 'Search for by name or area',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(104, 0, 0, 0),
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
                      '/view-requests-filters-screen',
                    ) as Map<String, dynamic>?;

                    setState(() {
                      if (updatedFilters != null) {
                        filters = updatedFilters;
                      }
                    });

                    daysOfWeekFilter = filters['daysOfWeek'];
                    subjectsFilter = filters['subjects'];
                    numberOfSessionsFilter = filters['numberOfSessions'];
                    maximumTotalFeeFilter = filters['maximumTotalFee'];
                    isFilter = filters['isFilter'];

                    // print('days Filter: ' + daysOfWeekFilter.toString());
                    // print('subjects Filter: ' + subjectsFilter.toString());
                    // print('sessions Filter: $numberOfSessionsFilter');
                    // print('fee Filter: $maximumTotalFeeFilter');
                    // print('Filter: $isFilter');
                  },
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Color(0xFF20464E),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contracts')
                    .where('status', isEqualTo: "Awaiting")
                    .where('isRequest', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            if (search.isEmpty && isFilter == false) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 4,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Image.asset(
                                              'assets/images/profile.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                                      data['studentName'],
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Lato',
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      data['subjects']
                                                          .join(', '),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Lato',
                                                        fontSize: 16,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      softWrap: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Rs. ${data['totalFee'].toStringAsFixed(0).toString()}',
                                                      style: const TextStyle(
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
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 45),
                                            child: Icon(
                                              CustomIcons.icons8_help_96,
                                              color: Color(0xFF4ECDE6),
                                              size: 33,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF4ECDE6),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFF4ECDE6),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Text(
                                                        "Request Details")),
                                                contentTextStyle:
                                                    const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Lato',
                                                  fontSize: 16,
                                                ),
                                                titleTextStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Righteous',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Request Status',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data[
                                                                  'status']),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Student name',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data[
                                                                  'studentName']),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Subjects',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data[
                                                                      'subjects']
                                                                  .join(', ')),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Session days',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data['days']
                                                                  .join(', ')),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Number of sessions [per subject]',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data[
                                                                      'numberOfSessions']
                                                                  .toString()),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Total contract amount',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                  'Rs. ${data['totalFee'].toStringAsFixed(0)}'),
                                                              const SizedBox(
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
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 15,
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      side: const BorderSide(
                                                          color:
                                                              Color(0xFF60D2E9),
                                                          width: 1),
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF60D2E9),
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
                                                              .where(
                                                                  'contractID',
                                                                  isEqualTo: data[
                                                                      'contractID'])
                                                              .get();
                                                      if (snapshot
                                                          .docs.isNotEmpty) {
                                                        DocumentReference
                                                            docRef = snapshot
                                                                .docs
                                                                .first
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
                                                            await tutorRef
                                                                .get();

                                                        // docRef  == contract, tutorRef = tutors

                                                        DocumentSnapshot
                                                            contractDataSnapshot =
                                                            await docRef.get();
                                                        Map<String, dynamic>
                                                            contractData =
                                                            contractDataSnapshot
                                                                    .data()!
                                                                as Map<String,
                                                                    dynamic>;
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
                                                        await tutorRef.update({
                                                          'inContract': true
                                                        });

                                                        docRef.update({
                                                          'members.0':
                                                              tutorData[
                                                                  'email'],
                                                        });
                                                        docRef.update({
                                                          'tutorName':
                                                              tutorData[
                                                                  'fullName'],
                                                        });

                                                        List<String>
                                                            selectedDayStrings =
                                                            contractData[
                                                                'days'];

                                                        DateTime startDate =
                                                            DateTime.now();
                                                        DateTime endDate =
                                                            DateTime.now();
                                                        Map<DateTime,
                                                                List<String>>
                                                            sessionDates = {};

                                                        int numSessions = int
                                                            .parse(contractData[
                                                                'numberOfSessions']);

                                                        // Get today's date
                                                        DateTime currentDate =
                                                            DateTime.now();

                                                        bool isTodayIncluded =
                                                            selectedDayStrings
                                                                .contains(DateFormat(
                                                                        'EEEE')
                                                                    .format(
                                                                        currentDate));
                                                        final dayValue =
                                                            selectedDayStrings
                                                                .indexOf(DateFormat(
                                                                        'EEEE')
                                                                    .format(
                                                                        currentDate));

                                                        // If today is Monday and selectedDayStrings contains only Monday, skip to next week
                                                        if (isTodayIncluded &&
                                                            currentDate
                                                                    .weekday ==
                                                                getDayOfWeek(
                                                                    selectedDayStrings[
                                                                        dayValue]) &&
                                                            selectedDayStrings
                                                                    .length ==
                                                                1) {
                                                          currentDate =
                                                              currentDate.add(
                                                                  Duration(
                                                                      days: 7));
                                                        }

                                                        // If today is Monday and selectedDayStrings contains Monday, skip to next randomized day
                                                        if (isTodayIncluded &&
                                                            currentDate
                                                                    .weekday ==
                                                                getDayOfWeek(
                                                                    selectedDayStrings[
                                                                        dayValue])) {
                                                          currentDate =
                                                              currentDate.add(
                                                                  Duration(
                                                                      days: 1));
                                                          while (selectedDayStrings
                                                                  .indexOf(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate)) ==
                                                              -1) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                          }
                                                        }

                                                        // If today is a randomized day, skip to next randomized day
                                                        while (selectedDayStrings
                                                                .indexOf(DateFormat(
                                                                        'EEEE')
                                                                    .format(
                                                                        currentDate)) ==
                                                            -1) {
                                                          currentDate =
                                                              currentDate.add(
                                                                  Duration(
                                                                      days: 1));
                                                        }

                                                        // Set start date as currentDate
                                                        startDate = currentDate;

                                                        // Set end date as the date of the last session
                                                        int sessionsLeft =
                                                            numSessions - 1;
                                                        while (
                                                            sessionsLeft > 0) {
                                                          currentDate =
                                                              currentDate.add(
                                                                  Duration(
                                                                      days: 1));
                                                          if (selectedDayStrings
                                                                  .indexOf(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate)) !=
                                                              -1) {
                                                            sessionsLeft--;
                                                          }
                                                        }
                                                        endDate = currentDate;

                                                        DateTime sessionDate =
                                                            startDate;
                                                        while (sessionDate
                                                                .isBefore(
                                                                    endDate) ||
                                                            sessionDate
                                                                .isAtSameMomentAs(
                                                                    endDate)) {
                                                          String dayName =
                                                              DateFormat('EEEE')
                                                                  .format(
                                                                      sessionDate);
                                                          if (selectedDayStrings
                                                              .contains(
                                                                  dayName)) {
                                                            sessionDates[
                                                                sessionDate] = [
                                                              '',
                                                              ''
                                                            ];
                                                            // print(
                                                            //     '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(sessionDate)}');
                                                          }
                                                          sessionDate =
                                                              sessionDate.add(
                                                                  Duration(
                                                                      days: 1));
                                                        }
                                                        docRef.update({
                                                          'members.0':
                                                              tutorData[
                                                                  'email'],
                                                        });
                                                        docRef.update({
                                                          'sessionDates':
                                                              sessionDates
                                                        });

                                                        docRef.update({
                                                          'startDate': startDate
                                                        });
                                                        docRef.update({
                                                          'endDate': endDate
                                                        });
                                                      }

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Text(
                                                            'Contract is now in progress',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                          duration:
                                                              const Duration(
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
                                                                    .circular(
                                                                        18),
                                                          ),
                                                          elevation: 30,
                                                          margin:
                                                              EdgeInsets.only(
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Righteous',
                                                        fontSize: 18,
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
                                            color: Color.fromARGB(
                                                255, 162, 239, 254),
                                          ),
                                        ),
                                        child: const Text(
                                          'Preview',
                                          style: TextStyle(
                                            color: Color(0xFF173d45),
                                            fontFamily: 'Cabin',
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else if (((data['studentName']
                                    .toString()
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))) &&
                                (isFilter == false && search.isNotEmpty)) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 10,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Image.asset(
                                              'assets/images/profile.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                                      data['studentName'],
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Lato',
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      data['subjects']
                                                          .join(', '),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Lato',
                                                        fontSize: 16,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      softWrap: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Rs. ${data['totalFee'].toStringAsFixed(0).toString()}',
                                                      style: const TextStyle(
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
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 45),
                                            child: Icon(
                                              CustomIcons.icons8_help_96,
                                              color: Color(0xFF4ECDE6),
                                              size: 33,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF4ECDE6),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xFF4ECDE6),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Text(
                                                        "Request Details")),
                                                contentTextStyle:
                                                    const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Lato',
                                                  fontSize: 16,
                                                ),
                                                titleTextStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Righteous',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'Request Status',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data[
                                                                  'status']),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Student name',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data[
                                                                  'studentName']),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Subjects',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data[
                                                                      'subjects']
                                                                  .join(', ')),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Session days',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data['days']
                                                                  .join(', ')),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Number of sessions [per subject]',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(data[
                                                                      'numberOfSessions']
                                                                  .toString()),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const Text(
                                                                'Total contract amount',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                  'Rs. ${data['totalFee'].toStringAsFixed(0)}'),
                                                              const SizedBox(
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
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 15,
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      side: const BorderSide(
                                                          color:
                                                              Color(0xFF4ECDE6),
                                                          width: 1),
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF4ECDE6),
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
                                                              .where(
                                                                  'contractID',
                                                                  isEqualTo: data[
                                                                      'contractID'])
                                                              .get();
                                                      if (snapshot
                                                          .docs.isNotEmpty) {
                                                        DocumentReference
                                                            docRef = snapshot
                                                                .docs
                                                                .first
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
                                                            await tutorRef
                                                                .get();

                                                        // docRef  == contract, tutorRef = tutors

                                                        DocumentSnapshot
                                                            contractDataSnapshot =
                                                            await docRef.get();
                                                        Map<String, dynamic>
                                                            contractData =
                                                            contractDataSnapshot
                                                                    .data()!
                                                                as Map<String,
                                                                    dynamic>;
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
                                                        await tutorRef.update({
                                                          'inContract': true
                                                        });

                                                        docRef.update({
                                                          'members.0':
                                                              tutorData[
                                                                  'email'],
                                                        });
                                                        docRef.update({
                                                          'tutorName':
                                                              tutorData[
                                                                  'fullName'],
                                                        });

                                                        List<String>
                                                            selectedDayStrings =
                                                            contractData[
                                                                'days'];

                                                        DateTime startDate =
                                                            DateTime.now();
                                                        DateTime endDate =
                                                            DateTime.now();
                                                        Map<DateTime,
                                                                List<String>>
                                                            sessionDates = {};

                                                        int numSessions = int
                                                            .parse(contractData[
                                                                'numberOfSessions']);

                                                        // Get today's date
                                                        DateTime currentDate =
                                                            DateTime.now();

                                                        bool isTodayIncluded =
                                                            selectedDayStrings
                                                                .contains(DateFormat(
                                                                        'EEEE')
                                                                    .format(
                                                                        currentDate));
                                                        final dayValue =
                                                            selectedDayStrings
                                                                .indexOf(DateFormat(
                                                                        'EEEE')
                                                                    .format(
                                                                        currentDate));

                                                        // If today is Monday and selectedDayStrings contains only Monday, skip to next week
                                                        if (isTodayIncluded &&
                                                            currentDate
                                                                    .weekday ==
                                                                getDayOfWeek(
                                                                    selectedDayStrings[
                                                                        dayValue]) &&
                                                            selectedDayStrings
                                                                    .length ==
                                                                1) {
                                                          currentDate =
                                                              currentDate.add(
                                                                  Duration(
                                                                      days: 7));
                                                        }

                                                        // If today is Monday and selectedDayStrings contains Monday, skip to next randomized day
                                                        if (isTodayIncluded &&
                                                            currentDate
                                                                    .weekday ==
                                                                getDayOfWeek(
                                                                    selectedDayStrings[
                                                                        dayValue])) {
                                                          currentDate =
                                                              currentDate.add(
                                                                  Duration(
                                                                      days: 1));
                                                          while (selectedDayStrings
                                                                  .indexOf(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate)) ==
                                                              -1) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                          }
                                                        }

                                                        // If today is a randomized day, skip to next randomized day
                                                        while (selectedDayStrings
                                                                .indexOf(DateFormat(
                                                                        'EEEE')
                                                                    .format(
                                                                        currentDate)) ==
                                                            -1) {
                                                          currentDate =
                                                              currentDate.add(
                                                                  Duration(
                                                                      days: 1));
                                                        }

                                                        // Set start date as currentDate
                                                        startDate = currentDate;

                                                        // Set end date as the date of the last session
                                                        int sessionsLeft =
                                                            numSessions - 1;
                                                        while (
                                                            sessionsLeft > 0) {
                                                          currentDate =
                                                              currentDate.add(
                                                                  Duration(
                                                                      days: 1));
                                                          if (selectedDayStrings
                                                                  .indexOf(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate)) !=
                                                              -1) {
                                                            sessionsLeft--;
                                                          }
                                                        }
                                                        endDate = currentDate;

                                                        DateTime sessionDate =
                                                            startDate;
                                                        while (sessionDate
                                                                .isBefore(
                                                                    endDate) ||
                                                            sessionDate
                                                                .isAtSameMomentAs(
                                                                    endDate)) {
                                                          String dayName =
                                                              DateFormat('EEEE')
                                                                  .format(
                                                                      sessionDate);
                                                          if (selectedDayStrings
                                                              .contains(
                                                                  dayName)) {
                                                            sessionDates[
                                                                sessionDate] = [
                                                              '',
                                                              ''
                                                            ];
                                                            // print(
                                                            //     '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(sessionDate)}');
                                                          }
                                                          sessionDate =
                                                              sessionDate.add(
                                                                  Duration(
                                                                      days: 1));
                                                        }
                                                        docRef.update({
                                                          'members.0':
                                                              tutorData[
                                                                  'email'],
                                                        });
                                                        docRef.update({
                                                          'sessionDates':
                                                              sessionDates
                                                        });

                                                        docRef.update({
                                                          'startDate': startDate
                                                        });
                                                        docRef.update({
                                                          'endDate': endDate
                                                        });
                                                      }

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Text(
                                                            'Contract is now in progress',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                          duration:
                                                              const Duration(
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
                                                                    .circular(
                                                                        18),
                                                          ),
                                                          elevation: 30,
                                                          margin:
                                                              EdgeInsets.only(
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF20464E),
                                                        fontFamily: 'Righteous',
                                                        fontSize: 18,
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
                                            width: 2,
                                            color: Color.fromARGB(
                                                255, 162, 239, 254),
                                          ),
                                        ),
                                        child: const Text(
                                          'Preview',
                                          style: TextStyle(
                                            color: Color(0xFF173d45),
                                            fontFamily: 'Cabin',
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else if (search.isEmpty && isFilter == true) {
                              bool filterCondition = true;

                              List<dynamic> subjectsDynamic = data['subjects'];
                              List<String> allSubjects =
                                  List<String>.from(subjectsDynamic);
                              List<String> filterSubjects = [];

                              filters['subjects'] != null
                                  ? filterSubjects = filters['subjects']
                                      .split(', ') as List<String>
                                  : null;

                              List<dynamic> daysDynamic = data['days'];
                              List<String> allDays =
                                  List<String>.from(daysDynamic);
                              List<String> filterDays = [];
                              filters['daysOfWeek'] != null
                                  ? filterDays = filters['daysOfWeek']
                                      .split(', ') as List<String>
                                  : null;

                              if (filters['subjects'] != null) {
                                filterCondition &= (filterSubjects.every(
                                    (filterSubject) => allSubjects.any(
                                        (subject) => subject
                                            .toLowerCase()
                                            .contains(
                                                filterSubject.toLowerCase()))));
                              }
                              if (filters['daysOfWeek'] != null) {
                                filterCondition &= (filterDays.every(
                                    (filterDays) => allDays.any((day) => day
                                        .toLowerCase()
                                        .contains(filterDays.toLowerCase()))));
                              }
                              if (filters['maximumTotalFee'] != null) {
                                filterCondition &= (data['totalFee'] <=
                                    filters['maximumTotalFee']);
                              }
                              if (filters['numberOfSessions'] != null) {
                                filterCondition &= (data['numberOfSessions'] ==
                                    filters['numberOfSessions']);
                              }
                              if (filterCondition) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.transparent),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Image.asset(
                                                'assets/images/profile.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.56,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data['studentName'],
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Lato',
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        data['subjects']
                                                            .join(', '),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Lato',
                                                          fontSize: 16,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Rs. ${data['totalFee'].toStringAsFixed(0).toString()}',
                                                        style: const TextStyle(
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
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 45),
                                              child: Icon(
                                                CustomIcons.icons8_help_96,
                                                color: Color(0xFF4ECDE6),
                                                size: 33,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
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
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  title: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFF4ECDE6),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xFF4ECDE6),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Text(
                                                          "Request Details")),
                                                  contentTextStyle:
                                                      const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                  ),
                                                  titleTextStyle:
                                                      const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Righteous',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  content: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  'Request Status',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                    'status']),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Student name',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                    'studentName']),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Subjects',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                        'subjects']
                                                                    .join(
                                                                        ', ')),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Session days',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                        'days']
                                                                    .join(
                                                                        ', ')),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Number of sessions [per subject]',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                        'numberOfSessions']
                                                                    .toString()),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Total contract amount',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                    'Rs. ${data['totalFee'].toStringAsFixed(0)}'),
                                                                const SizedBox(
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
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 15,
                                                    vertical: 15,
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        side: const BorderSide(
                                                            color: Color(
                                                                0xFF4ECDE6),
                                                            width: 1),
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF4ECDE6),
                                                        elevation: 15,
                                                        fixedSize: Size(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.25,
                                                            MediaQuery.of(
                                                                        context)
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
                                                                .where(
                                                                    'contractID',
                                                                    isEqualTo: data[
                                                                        'contractID'])
                                                                .get();
                                                        if (snapshot
                                                            .docs.isNotEmpty) {
                                                          DocumentReference
                                                              docRef = snapshot
                                                                  .docs
                                                                  .first
                                                                  .reference;
                                                          await docRef.update({
                                                            'status':
                                                                "inProgress"
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
                                                              await tutorRef
                                                                  .get();

                                                          // docRef  == contract, tutorRef = tutors

                                                          DocumentSnapshot
                                                              contractDataSnapshot =
                                                              await docRef
                                                                  .get();
                                                          Map<String, dynamic>
                                                              contractData =
                                                              contractDataSnapshot
                                                                      .data()!
                                                                  as Map<String,
                                                                      dynamic>;
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
                                                          await tutorRef
                                                              .update({
                                                            'contractedStudents':
                                                                contractedStudents,
                                                          });
                                                          await tutorRef
                                                              .update({
                                                            'inContract': true
                                                          });

                                                          docRef.update({
                                                            'members.0':
                                                                tutorData[
                                                                    'email'],
                                                          });
                                                          docRef.update({
                                                            'tutorName':
                                                                tutorData[
                                                                    'fullName'],
                                                          });

                                                          List<String>
                                                              selectedDayStrings =
                                                              contractData[
                                                                  'days'];

                                                          DateTime startDate =
                                                              DateTime.now();
                                                          DateTime endDate =
                                                              DateTime.now();
                                                          Map<DateTime,
                                                                  List<String>>
                                                              sessionDates = {};

                                                          int numSessions = int
                                                              .parse(contractData[
                                                                  'numberOfSessions']);

                                                          // Get today's date
                                                          DateTime currentDate =
                                                              DateTime.now();

                                                          bool isTodayIncluded =
                                                              selectedDayStrings
                                                                  .contains(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate));
                                                          final dayValue =
                                                              selectedDayStrings
                                                                  .indexOf(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate));

                                                          // If today is Monday and selectedDayStrings contains only Monday, skip to next week
                                                          if (isTodayIncluded &&
                                                              currentDate
                                                                      .weekday ==
                                                                  getDayOfWeek(
                                                                      selectedDayStrings[
                                                                          dayValue]) &&
                                                              selectedDayStrings
                                                                      .length ==
                                                                  1) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            7));
                                                          }

                                                          // If today is Monday and selectedDayStrings contains Monday, skip to next randomized day
                                                          if (isTodayIncluded &&
                                                              currentDate
                                                                      .weekday ==
                                                                  getDayOfWeek(
                                                                      selectedDayStrings[
                                                                          dayValue])) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                            while (selectedDayStrings
                                                                    .indexOf(DateFormat(
                                                                            'EEEE')
                                                                        .format(
                                                                            currentDate)) ==
                                                                -1) {
                                                              currentDate =
                                                                  currentDate.add(
                                                                      Duration(
                                                                          days:
                                                                              1));
                                                            }
                                                          }

                                                          // If today is a randomized day, skip to next randomized day
                                                          while (selectedDayStrings
                                                                  .indexOf(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate)) ==
                                                              -1) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                          }

                                                          // Set start date as currentDate
                                                          startDate =
                                                              currentDate;

                                                          // Set end date as the date of the last session
                                                          int sessionsLeft =
                                                              numSessions - 1;
                                                          while (sessionsLeft >
                                                              0) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                            if (selectedDayStrings
                                                                    .indexOf(DateFormat(
                                                                            'EEEE')
                                                                        .format(
                                                                            currentDate)) !=
                                                                -1) {
                                                              sessionsLeft--;
                                                            }
                                                          }
                                                          endDate = currentDate;

                                                          DateTime sessionDate =
                                                              startDate;
                                                          while (sessionDate
                                                                  .isBefore(
                                                                      endDate) ||
                                                              sessionDate
                                                                  .isAtSameMomentAs(
                                                                      endDate)) {
                                                            String dayName =
                                                                DateFormat(
                                                                        'EEEE')
                                                                    .format(
                                                                        sessionDate);
                                                            if (selectedDayStrings
                                                                .contains(
                                                                    dayName)) {
                                                              sessionDates[
                                                                  sessionDate] = [
                                                                '',
                                                                ''
                                                              ];
                                                              // print(
                                                              //     '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(sessionDate)}');
                                                            }
                                                            sessionDate =
                                                                sessionDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                          }
                                                          docRef.update({
                                                            'members.0':
                                                                tutorData[
                                                                    'email'],
                                                          });
                                                          docRef.update({
                                                            'sessionDates':
                                                                sessionDates
                                                          });

                                                          docRef.update({
                                                            'startDate':
                                                                startDate
                                                          });
                                                          docRef.update({
                                                            'endDate': endDate
                                                          });
                                                        }

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                              'Contract is now in progress',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Lato',
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                            duration:
                                                                const Duration(
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
                                                                      .circular(
                                                                          18),
                                                            ),
                                                            elevation: 30,
                                                            margin:
                                                                EdgeInsets.only(
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'Accept',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF20464E),
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 18,
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
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.86,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            side: const BorderSide(
                                              width: 2,
                                              color: Color.fromARGB(
                                                  255, 162, 239, 254),
                                            ),
                                          ),
                                          child: const Text(
                                            'Preview',
                                            style: TextStyle(
                                              color: Color(0xFF173d45),
                                              fontFamily: 'Cabin',
                                              fontSize: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else if (((data['studentName']
                                    .toString()
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))) &&
                                isFilter == true) {
                              bool filterCondition = true;

                              List<dynamic> subjectsDynamic = data['subjects'];
                              List<String> allSubjects =
                                  List<String>.from(subjectsDynamic);
                              List<String> filterSubjects = [];

                              filters['subjects'] != null
                                  ? filterSubjects = filters['subjects']
                                      .split(', ') as List<String>
                                  : null;

                              List<dynamic> daysDynamic = data['days'];
                              List<String> allDays =
                                  List<String>.from(daysDynamic);
                              List<String> filterDays = [];
                              filters['daysOfWeek'] != null
                                  ? filterDays = filters['daysOfWeek']
                                      .split(', ') as List<String>
                                  : null;

                              if (filters['subjects'] != null) {
                                filterCondition &= (filterSubjects.every(
                                    (filterSubject) => allSubjects.any(
                                        (subject) => subject
                                            .toLowerCase()
                                            .contains(
                                                filterSubject.toLowerCase()))));
                              }
                              if (filters['daysOfWeek'] != null) {
                                filterCondition &= (filterDays.every(
                                    (filterDays) => allDays.any((day) => day
                                        .toLowerCase()
                                        .contains(filterDays.toLowerCase()))));
                              }
                              if (filters['maximumTotalFee'] != null) {
                                filterCondition &= (data['totalFee'] <=
                                    filters['maximumTotalFee']);
                              }
                              if (filters['numberOfSessions'] != null) {
                                filterCondition &= (data['numberOfSessions'] ==
                                    filters['numberOfSessions']);
                              }
                              if (filterCondition) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.transparent),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 10,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Image.asset(
                                                'assets/images/profile.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.56,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data['studentName'],
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Lato',
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        data['subjects']
                                                            .join(', '),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Lato',
                                                          fontSize: 16,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Rs. ${data['totalFee'].toStringAsFixed(0).toString()}',
                                                        style: const TextStyle(
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
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 45),
                                              child: Icon(
                                                CustomIcons.icons8_help_96,
                                                color: Color(0xFF4ECDE6),
                                                size: 33,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
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
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  title: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFF4ECDE6),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xFF4ECDE6),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Text(
                                                          "Request Details")),
                                                  contentTextStyle:
                                                      const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Lato',
                                                    fontSize: 16,
                                                  ),
                                                  titleTextStyle:
                                                      const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Righteous',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  content: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  'Request Status',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                    'status']),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Student name',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                    'studentName']),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Subjects',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                        'subjects']
                                                                    .join(
                                                                        ', ')),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Session days',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                        'days']
                                                                    .join(
                                                                        ', ')),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Number of sessions [per subject]',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(data[
                                                                        'numberOfSessions']
                                                                    .toString()),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  'Total contract amount',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Text(
                                                                    'Rs. ${data['totalFee'].toStringAsFixed(0)}'),
                                                                const SizedBox(
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
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 15,
                                                    vertical: 15,
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        side: const BorderSide(
                                                            color: Color(
                                                                0xFF4ECDE6),
                                                            width: 1),
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF4ECDE6),
                                                        elevation: 15,
                                                        fixedSize: Size(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.25,
                                                            MediaQuery.of(
                                                                        context)
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
                                                                .where(
                                                                    'contractID',
                                                                    isEqualTo: data[
                                                                        'contractID'])
                                                                .get();
                                                        if (snapshot
                                                            .docs.isNotEmpty) {
                                                          DocumentReference
                                                              docRef = snapshot
                                                                  .docs
                                                                  .first
                                                                  .reference;
                                                          await docRef.update({
                                                            'status':
                                                                "inProgress"
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
                                                              await tutorRef
                                                                  .get();

                                                          // docRef  == contract, tutorRef = tutors

                                                          DocumentSnapshot
                                                              contractDataSnapshot =
                                                              await docRef
                                                                  .get();
                                                          Map<String, dynamic>
                                                              contractData =
                                                              contractDataSnapshot
                                                                      .data()!
                                                                  as Map<String,
                                                                      dynamic>;
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
                                                          await tutorRef
                                                              .update({
                                                            'contractedStudents':
                                                                contractedStudents,
                                                          });
                                                          await tutorRef
                                                              .update({
                                                            'inContract': true
                                                          });

                                                          docRef.update({
                                                            'members.0':
                                                                tutorData[
                                                                    'email'],
                                                          });
                                                          docRef.update({
                                                            'tutorName':
                                                                tutorData[
                                                                    'fullName'],
                                                          });

                                                          List<String>
                                                              selectedDayStrings =
                                                              contractData[
                                                                  'days'];

                                                          DateTime startDate =
                                                              DateTime.now();
                                                          DateTime endDate =
                                                              DateTime.now();
                                                          Map<DateTime,
                                                                  List<String>>
                                                              sessionDates = {};

                                                          int numSessions = int
                                                              .parse(contractData[
                                                                  'numberOfSessions']);

                                                          // Get today's date
                                                          DateTime currentDate =
                                                              DateTime.now();

                                                          bool isTodayIncluded =
                                                              selectedDayStrings
                                                                  .contains(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate));
                                                          final dayValue =
                                                              selectedDayStrings
                                                                  .indexOf(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate));

                                                          // If today is Monday and selectedDayStrings contains only Monday, skip to next week
                                                          if (isTodayIncluded &&
                                                              currentDate
                                                                      .weekday ==
                                                                  getDayOfWeek(
                                                                      selectedDayStrings[
                                                                          dayValue]) &&
                                                              selectedDayStrings
                                                                      .length ==
                                                                  1) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            7));
                                                          }

                                                          // If today is Monday and selectedDayStrings contains Monday, skip to next randomized day
                                                          if (isTodayIncluded &&
                                                              currentDate
                                                                      .weekday ==
                                                                  getDayOfWeek(
                                                                      selectedDayStrings[
                                                                          dayValue])) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                            while (selectedDayStrings
                                                                    .indexOf(DateFormat(
                                                                            'EEEE')
                                                                        .format(
                                                                            currentDate)) ==
                                                                -1) {
                                                              currentDate =
                                                                  currentDate.add(
                                                                      Duration(
                                                                          days:
                                                                              1));
                                                            }
                                                          }

                                                          // If today is a randomized day, skip to next randomized day
                                                          while (selectedDayStrings
                                                                  .indexOf(DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          currentDate)) ==
                                                              -1) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                          }

                                                          // Set start date as currentDate
                                                          startDate =
                                                              currentDate;

                                                          // Set end date as the date of the last session
                                                          int sessionsLeft =
                                                              numSessions - 1;
                                                          while (sessionsLeft >
                                                              0) {
                                                            currentDate =
                                                                currentDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                            if (selectedDayStrings
                                                                    .indexOf(DateFormat(
                                                                            'EEEE')
                                                                        .format(
                                                                            currentDate)) !=
                                                                -1) {
                                                              sessionsLeft--;
                                                            }
                                                          }
                                                          endDate = currentDate;

                                                          DateTime sessionDate =
                                                              startDate;
                                                          while (sessionDate
                                                                  .isBefore(
                                                                      endDate) ||
                                                              sessionDate
                                                                  .isAtSameMomentAs(
                                                                      endDate)) {
                                                            String dayName =
                                                                DateFormat(
                                                                        'EEEE')
                                                                    .format(
                                                                        sessionDate);
                                                            if (selectedDayStrings
                                                                .contains(
                                                                    dayName)) {
                                                              sessionDates[
                                                                  sessionDate] = [
                                                                '',
                                                                ''
                                                              ];
                                                              // print(
                                                              //     '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(sessionDate)}');
                                                            }
                                                            sessionDate =
                                                                sessionDate.add(
                                                                    Duration(
                                                                        days:
                                                                            1));
                                                          }
                                                          docRef.update({
                                                            'members.0':
                                                                tutorData[
                                                                    'email'],
                                                          });
                                                          docRef.update({
                                                            'sessionDates':
                                                                sessionDates
                                                          });

                                                          docRef.update({
                                                            'startDate':
                                                                startDate
                                                          });
                                                          docRef.update({
                                                            'endDate': endDate
                                                          });
                                                        }

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                              'Contract is now in progress',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Lato',
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                            duration:
                                                                const Duration(
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
                                                                      .circular(
                                                                          18),
                                                            ),
                                                            elevation: 30,
                                                            margin:
                                                                EdgeInsets.only(
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'Accept',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF20464E),
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 18,
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
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.86,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            side: const BorderSide(
                                              width: 2,
                                              color: Color.fromARGB(
                                                  255, 162, 239, 254),
                                            ),
                                          ),
                                          child: const Text(
                                            'Preview',
                                            style: TextStyle(
                                              color: Color(0xFF173d45),
                                              fontFamily: 'Cabin',
                                              fontSize: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
