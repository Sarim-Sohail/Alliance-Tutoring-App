// ignore_for_file: must_be_immutable, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class ContractDetailScreen extends StatefulWidget {
  Map<String, dynamic> data;

  ContractDetailScreen({
    super.key,
    required this.data,
  });

  @override
  State<ContractDetailScreen> createState() => _ContractDetailScreenState();
}

class _ContractDetailScreenState extends State<ContractDetailScreen> {
  List<bool> selectedSessionDates = [];
  List<MapEntry<DateTime?, List<String>>> sessionDatesList = [];
  late List<TextEditingController> sessionNoteControllers = List.generate(
      selectedSessionDates.length, (index) => TextEditingController());
  late List<String> sessionNotes =
      List.generate(selectedSessionDates.length, (index) => '');
  late List<String> sessionStatuses =
      List.generate(selectedSessionDates.length, (index) => '');

  Future<void> _fetchList() async {
    Map<DateTime?, List<String>>? sessionDates =
        (widget.data['sessionDates'] as Map<dynamic, dynamic>).map(
            (key, value) => MapEntry(
                DateTime.tryParse(key.toString()), List<String>.from(value)));

    sessionDatesList = sessionDates.entries.toList()
      ..sort((a, b) => a.key!.compareTo(b.key!));

    if (widget.data['status'] == 'Completed') {
      selectedSessionDates =
          List.generate(sessionDatesList.length, (_) => true);
    } else {
      selectedSessionDates = sessionDatesList
          .map((entry) => entry.value.isNotEmpty && entry.value[0] == 'true')
          .toList();
    }

    sessionStatuses = sessionDatesList
        .map((entry) => entry.value.isNotEmpty ? entry.value[0] : '')
        .toList();
    sessionNotes = sessionDatesList
        .map((entry) => entry.value.isNotEmpty ? entry.value[1] : '')
        .toList();

    for (int i = 0; i < sessionNotes.length; i++) {
      if (sessionNotes[i] != '') {
        sessionNoteControllers[i].text = sessionNotes[i];
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    _fetchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contract details',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF4ECDE6),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.asset(
                      'assets/images/contract-details.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                width: MediaQuery.of(context).size.width * 0.95,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contract Status',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (widget.data['status'] == 'inProgress')
                            ? 'Ongoing'
                            : 'Completed',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Tutor name',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.data['tutorName'],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Student name',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.data['studentName'],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Subjects',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.data['subjects'].join(', '),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Session days',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.data['days'].join(', '),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Number of sessions [per subject]',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.data['numberOfSessions'].toString(),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Start date',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy')
                            .format(DateTime.parse(widget.data['startDate'])),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'End date',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('EEEE, MMMM d, yyyy')
                            .format(DateTime.parse(widget.data['endDate'])),
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Total contract amount',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rs. ${widget.data['totalFee'].toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Lato',
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Session dates',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lato',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      for (int i = 0; i < sessionDatesList.length; i++)
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.61,
                                  child: Text(
                                    DateFormat('EEEE, MMMM d, yyyy')
                                        .format(sessionDatesList[i].key!),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontFamily: 'Lato',
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.grey,
                                    fillColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        return const Color(0xFF4ECDE6);
                                      },
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    value: selectedSessionDates[i],
                                    onChanged: (currentUser!.email ==
                                                widget.data['members'][0]) &&
                                            (widget.data['status'] ==
                                                "inProgress")
                                        ? ((value) {
                                            setState(() {
                                              selectedSessionDates[i] = value!;
                                              if (value == false) {
                                                sessionStatuses[i] = 'false';
                                              } else if (value == true) {
                                                sessionStatuses[i] = 'true';
                                              }
                                            });
                                          })
                                        : null),
                              ],
                            ),
                            Visibility(
                              visible: (selectedSessionDates[i] == true),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      enabled: (currentUser.email ==
                                                  widget.data['members'][0]) &&
                                              (widget.data['status'] ==
                                                  "inProgress")
                                          ? true
                                          : false,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter session milestones',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'OpenSans',
                                          fontSize: 15,
                                        ),
                                        contentPadding: EdgeInsets.all(8),
                                      ),
                                      controller: sessionNoteControllers[i],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'OpenSans',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible:
                            (currentUser!.email == widget.data['members'][0]) &&
                                ((widget.data['status'] == "inProgress")),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('contracts')
                                            .where('contractID',
                                                isEqualTo:
                                                    widget.data['contractID'])
                                            .get();

                                    DocumentReference contractRef =
                                        querySnapshot.docs[0].reference;

                                    for (int j = 0;
                                        j < sessionNoteControllers.length;
                                        j++) {
                                      sessionNotes[j] =
                                          sessionNoteControllers[j].text.trim();
                                    }

                                    // Sort sessionDates
                                    sessionDatesList.sort(
                                        (a, b) => a.key!.compareTo(b.key!));

                                    // Create a new map with the updated values
                                    final updatedSessionDates = {};
                                    for (int i = 0;
                                        i < sessionDatesList.length;
                                        i++) {
                                      final key = sessionDatesList[i]
                                          .key!
                                          .toIso8601String();
                                      final value = [
                                        sessionStatuses[i],
                                        sessionNotes[i],
                                      ];
                                      updatedSessionDates[key] = value;
                                    }

                                    // Update the document in Firestore
                                    await contractRef.update({
                                      'sessionDates': updatedSessionDates,
                                    });
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
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Righteous',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
