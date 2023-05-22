// ignore_for_file: unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutor_me/apis/meet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../widgets/carousel_render.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({Key? key}) : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  int currentPos = 0;
  late TextEditingController controller;
  String link = '';
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<String> listPaths = [
    "assets/images/carousel1.png",
    "assets/images/carousel2.png",
    "assets/images/carousel3.png",
  ];

  List<String> listTexts = [
    "Schedule meetings easily",
    "Start or Join a meeting",
    "Send in-call messages",
  ];

  // final ZoomMeeting zMeet = const ZoomMeeting();
  startNewMeeting(BuildContext context, String link) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ZoomMeeting(link: link)));
  }

  // Register the permissions callback, which handles the user's response to the
  Future<bool> getPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Meeting',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: CarouselSlider.builder(
                      itemCount: listPaths.length,
                      options: CarouselOptions(
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentPos = index;
                            });
                          }),
                      itemBuilder: (context, index, _) {
                        return CarouselRender(
                            listTexts[index], listPaths[index]);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: listPaths.map((url) {
                        int index = listPaths.indexOf(url);
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 7.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPos == index
                                ? Color(0xFF4ECDE6)
                                : Color.fromARGB(102, 121, 119, 119),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    //Ask for meeting link before joining
                    final link = await inputMeeting();
                    if (link == null || link.isEmpty) {
                      return;
                    }
                    setState((() => this.link = link));
                    getPermissions();
                    startNewMeeting(context, link);

                    final meetings =
                        FirebaseFirestore.instance.collection('meetings');
                    final snapshot =
                        await meetings.where('link', isEqualTo: link).get();
                    if (snapshot.docs.isNotEmpty) {
                      final doc = snapshot.docs.first;
                      final data = doc.data();
                      final memberCount = (data['memberCount'] ?? 0) + 1;
                      await doc.reference.update({'memberCount': memberCount});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color(0xFF60D2E9),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.06,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 22, 156, 183)),
                    ),
                  ),
                  child: Text(
                    'Join a new meeting',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Righteous',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await getRandomUnlockedRoom();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.06,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Color(0xFF4ECDE6)),
                    ),
                  ),
                  child: Text(
                    'Create a new meeting',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Righteous',
                      color: Color(0xFF20464E),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future getMeeting(String link) => showDialog(
        useRootNavigator: false,
        context: context,
        builder: ((context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Copy Meeting Code",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontFamily: 'OpenSans',
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              content: TextField(
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontFamily: 'OpenSans',
                  fontSize: 17,
                ),
                autofocus: true,
                controller: TextEditingController(
                  text: link,
                ),
                onSubmitted: (_) => submit(),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Color(0xFF60D2E9)),
                  onPressed: () {
                    copy(link);
                  },
                  child: Text(
                    "Copy",
                    style: TextStyle(
                      fontFamily: 'Righteous',
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Color(0xFF60D2E9)),
                    ),
                  ),
                  onPressed: submit,
                  child: Text(
                    "OK",
                    style: TextStyle(
                        fontFamily: 'Righteous', color: Color(0xFF60D2E9)),
                  ),
                ),
              ],
            )),
      );

  Future<String?> inputMeeting() => showDialog<String>(
        useRootNavigator: false,
        context: context,
        builder: ((context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Enter Meeting Link",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontFamily: 'OpenSans',
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              content: TextField(
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontFamily: 'OpenSans',
                  fontSize: 17,
                ),
                autofocus: true,
                controller: controller,
                onSubmitted: (_) => submit(),
                decoration: InputDecoration(
                  hintText: 'Paste meeting link',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade700,
                    fontFamily: 'OpenSans',
                    fontSize: 17,
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Color(0xFF60D2E9)),
                  onPressed: submit,
                  child: Text(
                    "Join",
                    style: TextStyle(
                      fontFamily: 'Righteous',
                    ),
                  ),
                ),
              ],
            )),
      );

  void copy(String link) {
    final data = ClipboardData(text: link);
    Clipboard.setData(data);
  }

  void submit() {
    Navigator.of(context).pop(controller.text.trim());
    controller.clear();
  }

  Future<void> getRandomUnlockedRoom() async {
    int rand = Random().nextInt(6);
    if (rand == 0) {
      rand = 1;
    }
    String no = rand.toString();
    final meetings = FirebaseFirestore.instance.collection('meetings');
    final snapshot = await meetings.doc('room_$no').get();
    Map<String, dynamic> data = snapshot.data()!;

    if (data['isLocked'] != true) {
      getMeeting('${data['link']}');
    } else {
      await getRandomUnlockedRoom();
    }
  }
}
