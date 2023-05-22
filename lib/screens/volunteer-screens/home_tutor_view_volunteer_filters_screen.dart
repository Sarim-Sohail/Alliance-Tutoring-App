// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, unnecessary_cast

import "package:flutter/material.dart";

class RequestFiltersScreen extends StatefulWidget {
  const RequestFiltersScreen({super.key});

  @override
  State<RequestFiltersScreen> createState() => _RequestFiltersScreenState();
}

class _RequestFiltersScreenState extends State<RequestFiltersScreen> {
  String? dropdownValue;
  bool isRadioOnline = false;
  String? radioOnline = 'Online';
  bool isRadioOffline = false;
  String? radioOffline = 'Offline';
  bool isRadioBoth = false;
  String? radioBoth = 'Both';

  bool isQualificationSelected = false;
  bool tutoringModeChanged = false;

  bool verified = false;
  final numberOfSessionsInputController = TextEditingController();
  final genderController = TextEditingController();
  final maximumFeeController = TextEditingController();

  List<bool> selectedSubjects = List.generate(7, (_) => false);
  List<String> selectedFilterSubjects = [];
  List<bool> selectedDays = List.generate(5, (_) => false);
  List<String> selectedFilterDays = [];

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

  Map<String, dynamic> filters = {
    'daysOfWeek': null,
    'numberOfSessions': null,
    'subjects': null,
    'maximumTotalFee': null,
    'isFilter': false,
  };

  @override
  void initState() {
    super.initState();
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
          'Request Filters',
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
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Select preferred days of week ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'OpenSans',
                    ),
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
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Monday",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedDays[0],
                      onChanged: (bool? value) async {
                        setState(() {
                          selectedDays[0] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Tuesday",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedDays[1],
                      onChanged: (bool? value) async {
                        setState(() {
                          selectedDays[1] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Wednesday",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedDays[2],
                      onChanged: (bool? value) async {
                        setState(() {
                          selectedDays[2] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Thursday",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedDays[3],
                      onChanged: (bool? value) async {
                        setState(() {
                          selectedDays[3] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Friday",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedDays[4],
                      onChanged: (bool? value) async {
                        setState(() {
                          selectedDays[4] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Enter preferred number of sessions ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 20),
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                  ),
                  controller: numberOfSessionsInputController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Enter maximum total fee',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 20),
                width: MediaQuery.of(context).size.width * 0.92,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                  ),
                  controller: maximumFeeController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Select preferred subjects',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Maths",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[0],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[0] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Physics",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[1],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[1] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Chemistry",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[2],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[2] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Biology",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[3],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[3] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "English",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[4],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[4] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Urdu",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[5],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[5] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Text(
                        "Computer Science",
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
                        return const Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[6],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedSubjects[6] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  for (int i = 0; i < selectedSubjects.length; i++) {
                    if (selectedSubjects[i]) {
                      selectedFilterSubjects.add(potentialSubjects[i]);
                    }
                  }

                  for (int i = 0; i < selectedDays.length; i++) {
                    if (selectedDays[i]) {
                      selectedFilterDays.add(potentialDays[i]);
                    }
                  }

                  if (selectedFilterDays.isEmpty &&
                      selectedFilterSubjects.isEmpty &&
                      numberOfSessionsInputController.text.isEmpty &&
                      maximumFeeController.text.isEmpty) {
                    filters['isFilter'] = false;
                  } else {
                    if (selectedFilterDays.isNotEmpty) {
                      filters['daysOfWeek'] =
                          selectedFilterDays.join(', ') as String;
                    }
                    if (numberOfSessionsInputController.text.isNotEmpty) {
                      filters['numberOfSessions'] = int.parse(
                          numberOfSessionsInputController.text.trim());
                    }
                    if (selectedFilterSubjects.isNotEmpty) {
                      filters['subjects'] =
                          selectedFilterSubjects.join(', ') as String;
                    }
                    if (maximumFeeController.text.isNotEmpty) {
                      filters['maximumTotalFee'] =
                          int.parse(maximumFeeController.text.trim());
                    }
                    filters['isFilter'] = true;
                  }
                  // print(selectedFilterDays);
                  // print(selectedFilterSubjects);
                  // print(filters['daysOfWeek']);
                  // print(filters['numberOfSessions']);
                  // print(filters['subjects']);
                  // print(filters['maximumTotalFee']);
                  Navigator.pop(context, filters);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF60D2E9),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.5,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                        color: Color(0xFF60D2E9)),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Righteous',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
