// ignore_for_file: unused_import, unnecessary_import, prefer_final_fields, unused_field, sized_box_for_whitespace, prefer_const_constructors, prefer_contains, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, dead_code, use_build_context_synchronously, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:tutor_me/models/contract_model.dart';
import 'package:uuid/uuid.dart';

import '../../../utilities/addresses.dart';
import '../../models/user_data_model.dart';

class RequestVolunteerScreen extends StatefulWidget {
  const RequestVolunteerScreen({super.key});

  @override
  State<RequestVolunteerScreen> createState() => _RequestVolunteerScreenState();
}

class _RequestVolunteerScreenState extends State<RequestVolunteerScreen> {
  String? dropdownValue;
  String? radioButtonValue = 'Online';
  bool isRadioOnline = false;
  String? radioOnline = 'Online';
  bool isRadioOffline = false;
  String? radioOffline = 'Offline';
  bool isRadioBoth = false;
  String? radioBoth = 'Both';

  String _groupValue = 'Online';
  List<String> _status = ["Online", "Physical", "Both"];

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
  Map<String, double> _prices = {
    for (var subject in [
      'Maths',
      'Physics',
      'Chemistry',
      'Biology',
      'English',
      'Urdu',
      'Comp. Science'
    ])
      subject: 0.0
  };

  Map<String, dynamic> _timings = {};

  // List<DateTime> _sessionDates = [];
  Map<DateTime, List<String>> _sessionDates = {};
  List<String> selectedDaysValues = [];
  List<bool> selectedSubjects = List.generate(7, (_) => false);
  List<bool> selectedDays = List.generate(5, (_) => false);

  late Map<String, dynamic> _userData;
  List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  var uuid = Uuid();

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

  final addressController = TextEditingController();
  final List<String> addresses = karachiAreas;

  List<TextEditingController> priceControllers = List.generate(
    7,
    (_) => TextEditingController(),
  );
  List<TextEditingController> timeControllers = List.generate(
    7,
    (_) => TextEditingController(),
  );

  List<String> potentialSubjects = [
    'Maths',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'Urdu',
    'Comp. Science'
  ];

  List<String> potentialDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  List<String> potentialTimings = [
    '8 AM to 9 AM',
    '9 AM to 10 AM',
    '10 AM to 11 AM',
    '11 AM to 12 PM',
    '12 PM to 1 PM',
    '1 PM to 2 PM',
    '2 PM to 3 PM',
    '3 PM to 4 PM',
    '4 PM to 5 PM',
    '5 PM to 6 PM',
    '6 PM to 7 PM',
    '7 PM to 8 PM',
    '8 PM to 9 PM',
    '9 PM to 10 PM',
  ];

  List<String> disabledTimings = [];

  List<String?> selectedTimings = List.generate(7, (_) => null);

  Map<String, double> _subjectsPrices = {};
  Map<String, dynamic> _subjectsTimings = {};
  List<String> daysOfWeek = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color(0xFF4ECDE6),
        title: const Text(
          'Request a volunteer',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/request-volunteer.png',
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              const SizedBox(
                height: 5,
              ),

              //Mode
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
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

              //Subject
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
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
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 0.5),
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
                        width: MediaQuery.of(context).size.width * 0.13,
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
                              selectedSubjectStrings
                                  .remove(_prices.keys.toList()[i].toString());
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

              //Select subject prices
              Visibility(
                visible: (selectedSubjects.contains(true)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        const Text(
                          'Select price for each subject ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const Text(
                          '*',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),

              for (int i = 0; i < 7; i++)
                if (selectedSubjects[i])
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          potentialSubjects[i],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                            cursorColor: Color(0xFF4ECDE6),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'OpenSans',
                            ),
                            controller: priceControllers[i],
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF4ECDE6),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xFF4ECDE6),
                                ),
                              ),
                              hintText: 'Price',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _prices[potentialSubjects[i]] =
                                    double.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
              if (selectedSubjects.contains(true))
                SizedBox(
                  height: 30,
                ),

              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
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
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 0.5),
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
                        width: MediaQuery.of(context).size.width * 0.13,
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
                          if (numberOfSessionsInputController.text.isNotEmpty &&
                              int.parse(numberOfSessionsInputController.text) >
                                  0 &&
                              selectedDays.any((day) => day)) {
                            for (int i = 0; i < _daysOfWeek.length; i++) {
                              if (selectedDays[i]) {
                                selectedDayStrings.add(_daysOfWeek[i]);
                              }
                            }
                            int numSessions =
                                int.parse(numberOfSessionsInputController.text);

                            // Get today's date
                            DateTime currentDate = DateTime.now();

                            bool isTodayIncluded = selectedDayStrings.contains(
                                DateFormat('EEEE').format(currentDate));
                            final dayValue = selectedDayStrings.indexOf(
                                DateFormat('EEEE').format(currentDate));

                            // If today is included and selectedDayStrings contains only today, skip to next week
                            if (isTodayIncluded &&
                                currentDate.weekday ==
                                    getDayOfWeek(
                                        selectedDayStrings[dayValue]) &&
                                selectedDayStrings.length == 1) {
                              currentDate = currentDate.add(Duration(days: 7));
                            }

                            // If today is Monday and selectedDayStrings contains Monday, skip to next randomized day
                            if (isTodayIncluded &&
                                currentDate.weekday ==
                                    getDayOfWeek(
                                        selectedDayStrings[dayValue])) {
                              currentDate = currentDate.add(Duration(days: 1));
                              while (selectedDayStrings.indexOf(
                                      DateFormat('EEEE').format(currentDate)) ==
                                  -1) {
                                currentDate =
                                    currentDate.add(Duration(days: 1));
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
                                _sessionDates[sessionDate] = ['false', ''];
                                // print(
                                //     '${DateFormat('EEEE, MMMM d, ' 'yyyy').format(sessionDate)}');
                              }
                              sessionDate = sessionDate.add(Duration(days: 1));
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

              //Select time for each subject
              Visibility(
                visible: (selectedSubjects.contains(true)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        const Text(
                          'Select time for each subject ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const Text(
                          '*',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              for (int i = 0; i < 7; i++)
                if (selectedSubjects[i])
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          potentialSubjects[i],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF4ECDE6), width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              iconStyleData: IconStyleData(
                                icon: Icon(Icons.expand_more),
                                iconEnabledColor: Color(0xFF4ECDE6),
                                iconDisabledColor: Color(0xFF4ECDE6),
                              ),
                              hint: Text(
                                selectedTimings[i] ?? 'Select Item',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'OpenSans',
                                  color: Colors.black,
                                ),
                              ),
                              items: potentialTimings.map((String value) {
                                if (disabledTimings.contains(value)) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    enabled: false,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 64, 132, 146),
                                      fontSize: 14,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                              value: selectedTimings[i],
                              onChanged: (value) {
                                setState(() {
                                  if (disabledTimings
                                      .contains(timeControllers[i].text)) {
                                    disabledTimings
                                        .remove(timeControllers[i].text);
                                  }
                                  timeControllers[i].text = value!;
                                  selectedTimings[i] = value;
                                  disabledTimings.add(value);
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

              Visibility(
                visible: (selectedSubjects.contains(true)),
                child: SizedBox(
                  height: 30,
                ),
              ),

              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
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
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 0.5),
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
                        String dayName = DateFormat('EEEE').format(sessionDate);
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
                      _contractTotal = 0;
                      for (int i = 0; i < 7; i++) {
                        if (selectedSubjects[i]) {
                          calc = double.parse(value) *
                              _prices.values.toList()[i].toDouble();
                          _contractTotal += calc;
                        }
                      }
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
                          width: MediaQuery.of(context).size.width * 0.05,
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
                                      border:
                                          Border.all(color: Color(0xFF4ECDE6)),
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
                                width: MediaQuery.of(context).size.width * 0.22,
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
                                      int.parse(numberOfSessionsInputController
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
                                      int.parse(numberOfSessionsInputController
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
                height: 50,
              ),

              //Submit button
              ElevatedButton(
                onPressed: () async {
                  if (selectedSubjects.contains(true) &&
                      selectedDays.contains(true) &&
                      numberOfSessionsInputController.text.isNotEmpty) {
                    registerRequest();
                    // await contractsRef
                    //     .doc(uuid.v1())
                    //     .set(newContract.toJson());
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please input all required fields',
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
                    MediaQuery.of(context).size.height * 0.06,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                        color: Color(0xFF60D2E9)),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Righteous',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future registerRequest() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email.toString();
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await docUser.get();
    final userdata = Users.fromJson(snapshot.data()!);

    CollectionReference contractsRef =
        FirebaseFirestore.instance.collection('contracts');
    selectedDaysValues
        .sort((a, b) => weekDays.indexOf(a).compareTo(weekDays.indexOf(b)));

    for (int i = 0; i < selectedSubjects.length; i++) {
      if (selectedSubjects[i]) {
        String subject = potentialSubjects[i];
        String price = priceControllers[i].text;
        _subjectsPrices[subject] = double.parse(price);
      }
    }

    for (int i = 0; i < selectedSubjects.length; i++) {
      if (selectedSubjects[i]) {
        String subject = potentialSubjects[i];
        String time = timeControllers[i].text;
        _subjectsTimings[subject] = time;
      }
    }

    ContractModel newContract = ContractModel(
      contractID: Uuid().v4(),
      tutorName: "TBD",
      studentName: userdata.fullName,
      startDate: _startDate,
      endDate: null,
      totalFee: _contractTotal,
      numberOfSessions: int.parse(numberOfSessionsInputController.text.trim()),
      status: 'Awaiting',
      subjectsTimings: _subjectsTimings,
      subjectsPrices: _subjectsPrices,
      days: selectedDaysValues,
      members: [
        "TBD", //tutorEmail, studentEmail
        userEmail.toString(),
      ],
      sessionDates: _sessionDates,
      subjects: selectedSubjectStrings,
      isRequest: true,
    );
    print('contractID: ${newContract.contractID}');
    print('tutorName: ${newContract.tutorName}');
    print('studentName: ${newContract.studentName}');
    print('startDate: ${newContract.startDate}');
    print('endDate: ${newContract.endDate}');
    print('totalFee: ${newContract.totalFee}');
    print('numberOfSessions: ${newContract.numberOfSessions}');
    print('status: ${newContract.status}');
    print('subjectsTimings: ${newContract.subjectsTimings}');
    print('subjectsPrices: ${newContract.subjectsPrices}');
    print('subjects: ${newContract.subjects}');
    print('days: ${newContract.days}');
    print('members: ${newContract.members}');
    print('sessionDates: ${newContract.sessionDates}');
    print('isRequest: ${newContract.isRequest}');

    contractsRef.doc(newContract.contractID).set(newContract.toJson());
  }
}
