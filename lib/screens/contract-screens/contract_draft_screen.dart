// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field, prefer_final_fields, avoid_print, unused_local_variable, prefer_contains, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:tutor_me/models/contract_model.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_view_detail_screen.dart';
import 'package:uuid/uuid.dart';

import 'contract_payment_screen.dart';

class DraftContract extends StatefulWidget {
  final String email;
  const DraftContract({super.key, required this.email});

  @override
  State<DraftContract> createState() => _DraftContractState();
}

class _DraftContractState extends State<DraftContract> {
  String _groupValue = 'Online';
  List<String> _status = [];

  bool english = false;
  bool monday = false;

  final numberOfSessionsInputController = TextEditingController();

  String _fullName = '';
  String _studentName = '';
  String _dateOfBirth = '';
  String _email = '';
  String _address = '';
  String _gender = '';
  String _mode = '';
  String _qualification = '';
  String _degreeNumber = '';
  String _tutoringMode = '';
  int _noOfReviews = 0;
  double _subTotal = 0;
  double _contractTotal = 0;
  double _rating = 0.0;
  bool _isVerified = false;
  Map<String, double> _prices = {};
  Map<String, dynamic> _timings = {};

  // List<DateTime> _sessionDates = [];
  Map<DateTime, List<String>> _sessionDates = {};
  List<String> selectedDaysValues = [];
  List<bool> selectedSubjects = List.generate(7, (_) => false);
  List<bool> selectedDays = List.generate(5, (_) => false);

  late Map<String, dynamic> _userData;
  List<String> _daysOfWeek = [];

  List<String> selectedSubjectStrings = [];

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

  List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    retrieveUserData(widget.email);
  }

  Future<void> retrieveUserData(String parameter) async {
    try {
      _studentName = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .get()
          .then((documentSnapshot) => documentSnapshot.get('fullName'));

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('tutors')
          .doc(parameter)
          .get();
      if (documentSnapshot.exists) {
        if (mounted) {
          setState(() {
            _userData = documentSnapshot.data() as Map<String, dynamic>;

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
            _address = documentSnapshot.get('address');
            _noOfReviews = documentSnapshot.get('numberOfReviews');
            _prices = mapPrices;
            _timings = mapTimings;
            _daysOfWeek = List<String>.from(documentSnapshot.get('daysOfWeek'));
            _qualification = documentSnapshot.get('qualification');
            _isVerified = documentSnapshot.get('isVerified');
            _rating = documentSnapshot.get('rating').toDouble();
            _mode = documentSnapshot.get('tutoringMode');

            if (_rating == 0 || _rating == 0.0) {
              _rating = 0.0;
            }
            if (_mode == 'Both') {
              _status = ["Online", "Offline"];
            } else if (_mode == 'Online') {
              _status = ["Online"];
            } else if (_mode == 'Offline (Physical)') {
              _status = ["Offline"];
            }
          });
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error retrieving user data: ');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFF4ECDE6),
        elevation: 0,
        title: const Text(
          'Draft a Contract',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Image.asset(
                    'assets/images/draft-contract.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Text(
                      'Tutor Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _fullName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w600,
                                ),
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
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Tutor Schedule',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Table(
                              border: TableBorder.all(
                                color: Color(0xFF4ECDE6),
                                width: 1,
                              ),
                              columnWidths: const {
                                0: FlexColumnWidth(3.5),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(4),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Subjects",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Fee per session",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Session Timings",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                for (var subject in _prices.keys)
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          subject.toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Rs. ${_prices[subject].toString()}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          _timings[subject].toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Text(
                      'Mode of Tutoring ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const Text(
                      '*',
                      style: TextStyle(color: Color(0xFF4ECDE6), fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: _groupValue,
                        horizontalAlignment: MainAxisAlignment.spaceEvenly,
                        onChanged: (value) => setState(() {
                          _groupValue = value ?? '';
                        }),
                        items: _status,
                        textStyle: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        activeColor: Colors.black,
                        fillColor: const Color(0xFF4ECDE6),
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Text(
                      'Subject (select atleast one) ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const Text(
                      '*',
                      style: TextStyle(color: Color(0xFF4ECDE6), fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                //SUBJECT CONTAINER
                for (int i = 0; i < _prices.keys.length; i++)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            _prices.keys.toList()[i].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.grey,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            return Color(0xFF4ECDE6);
                          }),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          value: selectedSubjects[i],
                          onChanged: (bool? value) async {
                            setState(() {
                              selectedSubjects[i] = value!;
                              if (value == true) {
                                selectedSubjectStrings
                                    .add(_prices.keys.toList()[i].toString());
                                _subTotal +=
                                    _prices.values.toList()[i].toDouble();
                                if (numberOfSessionsInputController
                                    .text.isNotEmpty) {
                                  double calc = 0;
                                  double noOfSessions = double.parse(
                                      numberOfSessionsInputController.text
                                          .trim());
                                  calc = noOfSessions *
                                      _prices.values.toList()[i].toDouble();
                                  _contractTotal += calc;
                                }
                              } else {
                                selectedSubjectStrings.remove(
                                    _prices.keys.toList()[i].toString());
                                _subTotal -=
                                    _prices.values.toList()[i].toDouble();
                                if (numberOfSessionsInputController
                                    .text.isNotEmpty) {
                                  double calc = 0;
                                  double noOfSessions = double.parse(
                                      numberOfSessionsInputController.text
                                          .trim());
                                  calc = noOfSessions *
                                      _prices.values.toList()[i].toDouble();
                                  _contractTotal -= calc;
                                }
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Text(
                      'Session days ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const Text(
                      '*',
                      style: TextStyle(color: Color(0xFF4ECDE6), fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //DAYS CONTAINER
                for (int i = 0; i < _daysOfWeek.length; i++)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            _daysOfWeek[i].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.grey,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            return Color(0xFF4ECDE6);
                          }),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          value: selectedDays[i],
                          onChanged: (bool? value) async {
                            setState(() {
                              selectedDays[i] = value!;
                            });
                            if (value == true) {
                              selectedDaysValues.add(_daysOfWeek[i].toString());
                            } else {
                              selectedDaysValues
                                  .remove(_daysOfWeek[i].toString());
                            }
                            List<String> selectedDayStrings = [];
                            if (numberOfSessionsInputController
                                    .text.isNotEmpty &&
                                int.parse(
                                        numberOfSessionsInputController.text) >
                                    0 &&
                                selectedDays.any((day) => day)) {
                              for (int i = 0; i < _daysOfWeek.length; i++) {
                                if (selectedDays[i]) {
                                  selectedDayStrings.add(_daysOfWeek[i]);
                                }
                              }
                              int numSessions = int.parse(
                                  numberOfSessionsInputController.text);

                              // Get today's date
                              DateTime currentDate = DateTime.now();

                              bool isTodayIncluded =
                                  selectedDayStrings.contains(
                                      DateFormat('EEEE').format(currentDate));
                              final dayValue = selectedDayStrings.indexOf(
                                  DateFormat('EEEE').format(currentDate));

                              // If today is included and selectedDayStrings contains only today, skip to next week
                              if (isTodayIncluded &&
                                  currentDate.weekday ==
                                      getDayOfWeek(
                                          selectedDayStrings[dayValue]) &&
                                  selectedDayStrings.length == 1) {
                                currentDate =
                                    currentDate.add(Duration(days: 7));
                              }

                              // If today is Monday and selectedDayStrings contains Monday, skip to next randomized day
                              if (isTodayIncluded &&
                                  currentDate.weekday ==
                                      getDayOfWeek(
                                          selectedDayStrings[dayValue])) {
                                currentDate =
                                    currentDate.add(Duration(days: 1));
                                while (selectedDayStrings.indexOf(
                                        DateFormat('EEEE')
                                            .format(currentDate)) ==
                                    -1) {
                                  currentDate =
                                      currentDate.add(Duration(days: 1));
                                }
                              }

                              // If today is a randomized day, skip to next randomized day
                              while (selectedDayStrings.indexOf(
                                      DateFormat('EEEE').format(currentDate)) ==
                                  -1) {
                                currentDate =
                                    currentDate.add(Duration(days: 1));
                              }

                              // Set start date as currentDate
                              _startDate = currentDate;

                              // Set end date as the date of the last session
                              int sessionsLeft = numSessions - 1;
                              while (sessionsLeft > 0) {
                                currentDate =
                                    currentDate.add(Duration(days: 1));
                                if (selectedDayStrings.indexOf(
                                        DateFormat('EEEE')
                                            .format(currentDate)) !=
                                    -1) {
                                  sessionsLeft--;
                                }
                              }
                              _endDate = currentDate;

                              DateTime sessionDate = _startDate;
                              while (sessionDate.isBefore(_endDate) ||
                                  sessionDate.isAtSameMomentAs(_endDate)) {
                                String dayName =
                                    DateFormat('EEEE').format(sessionDate);
                                if (selectedDayStrings.contains(dayName)) {
                                  _sessionDates[sessionDate] = ['false', ''];
                                  // print(
                                  //     '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(sessionDate)}');
                                }
                                sessionDate =
                                    sessionDate.add(Duration(days: 1));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Text(
                      'Number of sessions (enter atleast one) ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    const Text(
                      '*',
                      style: TextStyle(color: Color(0xFF4ECDE6), fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'OpenSans',
                    ),
                    onChanged: (value) {
                      if (value != '' &&
                          int.parse(value) > 0 &&
                          selectedDays.any((day) => day)) {
                        List<String> selectedDayStrings = [];
                        for (int i = 0; i < _daysOfWeek.length; i++) {
                          if (selectedDays[i]) {
                            selectedDayStrings.add(_daysOfWeek[i]);
                          }
                        }
                        int numSessions = int.parse(value);

                        // Get today's date
                        DateTime currentDate = DateTime.now();

                        bool isTodayIncluded = selectedDayStrings
                            .contains(DateFormat('EEEE').format(currentDate));
                        final dayValue = selectedDayStrings
                            .indexOf(DateFormat('EEEE').format(currentDate));

                        // If today is Monday and selectedDayStrings contains only Monday, skip to next week
                        if (isTodayIncluded &&
                            currentDate.weekday ==
                                getDayOfWeek(selectedDayStrings[dayValue]) &&
                            selectedDayStrings.length == 1) {
                          currentDate = currentDate.add(Duration(days: 7));
                        }

                        // If today is Monday and selectedDayStrings contains Monday, skip to next randomized day
                        if (isTodayIncluded &&
                            currentDate.weekday ==
                                getDayOfWeek(selectedDayStrings[dayValue])) {
                          currentDate = currentDate.add(Duration(days: 1));
                          while (selectedDayStrings.indexOf(
                                  DateFormat('EEEE').format(currentDate)) ==
                              -1) {
                            currentDate = currentDate.add(Duration(days: 1));
                          }
                        }

                        // If today is a randomized day, skip to next randomized day
                        while (selectedDayStrings.indexOf(
                                DateFormat('EEEE').format(currentDate)) ==
                            -1) {
                          currentDate = currentDate.add(Duration(days: 1));
                        }

                        // Set start date as currentDate
                        _startDate = currentDate;

                        // Set end date as the date of the last session
                        int sessionsLeft = numSessions - 1;
                        while (sessionsLeft > 0) {
                          currentDate = currentDate.add(Duration(days: 1));
                          if (selectedDayStrings.indexOf(
                                  DateFormat('EEEE').format(currentDate)) !=
                              -1) {
                            sessionsLeft--;
                          }
                        }
                        _endDate = currentDate;

                        DateTime sessionDate = _startDate;
                        while (sessionDate.isBefore(_endDate) ||
                            sessionDate.isAtSameMomentAs(_endDate)) {
                          String dayName =
                              DateFormat('EEEE').format(sessionDate);
                          if (selectedDayStrings.contains(dayName)) {
                            _sessionDates[sessionDate] = ['', ''];
                            // print(
                            //     '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(sessionDate)}');
                          }
                          sessionDate = sessionDate.add(Duration(days: 1));
                        }

                        // print(_startDate);
                        // print(_endDate);
                        // print(_sessionDates);

                        double calc = 0;
                        
                        for (int i = 0; i < 7; i++) {
                          if (selectedSubjects[i]) {
                            calc = double.parse(value) *
                                _prices.values.toList()[i].toDouble();
                            
                            setState(() {
                              _contractTotal += calc;
                            });
                          }
                        }
                      } else {
                        
                      }
                    },
                    controller: numberOfSessionsInputController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Visibility(
                  visible: selectedSubjects.any((element) => element),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Text(
                            'Your receipt',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(3.5),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(4),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Subjects",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Fee per session",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                for (int i = 0; i < 7; i++)
                                  if (selectedSubjects[i])
                                    TableRow(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFF4ECDE6)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _prices.keys.toList()[i],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontFamily: 'OpenSans',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Rs. ${_prices.values.toList()[i].toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontFamily: 'OpenSans',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                ),
                                Text(
                                  'Subtotal \u{2003}\u{2003}: \u{2003}\u{2003}Rs ${_subTotal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 17,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Contract Total : ',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 17,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rs ${_contractTotal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 17,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Start Date : ',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 17,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                (_startDate != _now &&
                                        numberOfSessionsInputController.text !=
                                            '' &&
                                        int.parse(
                                                numberOfSessionsInputController
                                                    .text) !=
                                            0 &&
                                        selectedDays.any((day) => day))
                                    ? Text(
                                        '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(_startDate)}',
                                        style: TextStyle(
                                          color: Color(0xFF2F7B8A),
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        'TBD',
                                        style: TextStyle(
                                          color: Color(0xFF2F7B8A),
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'End Date : ',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 17,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                (_endDate != _now &&
                                        numberOfSessionsInputController.text !=
                                            '' &&
                                        int.parse(
                                                numberOfSessionsInputController
                                                    .text) !=
                                            0 &&
                                        selectedDays.any((day) => day))
                                    ? Text(
                                        '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(_endDate)}',
                                        style: TextStyle(
                                          color: Color(0xFF2F7B8A),
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        'TBD',
                                        style: TextStyle(
                                          color: Color(0xFF2F7B8A),
                                          fontSize: 17,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 80,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedSubjects.contains(true) &&
                            selectedDays.contains(true) &&
                            numberOfSessionsInputController.text.isNotEmpty) {
                          CollectionReference contractsRef = FirebaseFirestore
                              .instance
                              .collection('contracts');
                          // for (int i = 0; i < selectedDays.length; i++) {
                          //   if (selectedDays[i]) {
                          //     selectedDayStrings.add(daysOfTheWeek[i]);
                          //     print(daysOfTheWeek[i]);
                          //   }
                          // }
                          // List<String> selectedSubjectStrings = [];
                          // for (int i = 0; i < selectedSubjects.length; i++) {
                          //   if (selectedSubjects[i]) {
                          //     selectedSubjectStrings.add(subjects[i]);
                          //     print(subjects[i]);
                          //   }
                          // }
                          // print("Break");
                          // print(selectedSubjectStrings);
                          // print(selectedDayStrings);
                          selectedDaysValues.sort((a, b) => weekDays
                              .indexOf(a)
                              .compareTo(weekDays.indexOf(b)));
                          ContractModel newContract = ContractModel(
                            contractID: Uuid().v4(),
                            tutorName: _fullName,
                            studentName: _studentName,
                            startDate: _startDate,
                            endDate: _endDate,
                            totalFee: _contractTotal,
                            numberOfSessions: int.parse(
                                numberOfSessionsInputController.text.trim()),
                            status: 'Pending',
                            subjectsTimings: _timings,
                            subjectsPrices: _prices,
                            subjects: selectedSubjectStrings,
                            days: selectedDaysValues,
                            members: [
                              _email, //tutorEmail, studentEmail
                              FirebaseAuth.instance.currentUser!.email
                                  .toString()
                            ],
                            sessionDates: _sessionDates,
                            isRequest: false,
                          );

                          await contractsRef
                              .doc(uuid.v1())
                              .set(newContract.toJson());

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ContractPayment();
                          }));
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please select and input all required fields',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                ),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red.shade800,
                              behavior: SnackBarBehavior.floating,
                              width: MediaQuery.of(context).size.width * 0.8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 20,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF60D2E9),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.5,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: Color(0xFF60D2E9)),
                        ),
                      ),
                      child: Text(
                        'Send',
                        style: const TextStyle(
                          fontSize: 25,
                          fontFamily: 'Righteous',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
