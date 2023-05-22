// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, prefer_is_empty, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';

import 'package:group_radio_button/group_radio_button.dart';
import 'package:html/parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tutor_me/models/user_data_model.dart';
import 'package:tutor_me/models/tutor_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tutor_me/utilities/stream.dart';

class BecomeTutor extends StatefulWidget {
  const BecomeTutor({super.key});

  @override
  State<BecomeTutor> createState() => _BecomeTutorState();
}

class _BecomeTutorState extends State<BecomeTutor> {
  String? dropdownValue;
  bool isQualificationSelected = false;
  String? radioButtonValue = 'Online';
  bool isRadioOnline = false;
  String? radioOnline = 'Online';
  bool isRadioOffline = false;
  String? radioOffline = 'Offline';
  bool isRadioBoth = false;
  String? radioBoth = 'Both';

  String _groupValue = 'Online';
  final _status = ["Online", "Offline (Physical)", "Both"];

  final experienceInputController = TextEditingController();
  final monthlyFeesInputController = TextEditingController();
  final weeklyFeesInputController = TextEditingController();
  final dailyFeesInputController = TextEditingController();
  final employmentInputController = TextEditingController();
  final degreeNumberInputController = TextEditingController();

  List<TextEditingController> priceControllers = List.generate(
    7,
    (_) => TextEditingController(),
  );
  List<TextEditingController> timeControllers = List.generate(
    7,
    (_) => TextEditingController(),
  );

  List<bool> selectedSubjects = List.generate(7, (_) => false);
  List<bool> selectedDays = List.generate(5, (_) => false);

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

  Map<String, double> subjectPrices = {};
  Map<String, dynamic> subjectTimings = {};
  List<String> daysOfWeek = [];
  File? imageFile;
  String imgURL = '';

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile xFile) async {
    ImageCropper imageCropper = ImageCropper();
    CroppedFile? croppedImage = await imageCropper.cropImage(
        sourcePath: xFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20,
        cropStyle: CropStyle.rectangle);
    File? file = croppedImage?.path != null ? File(croppedImage!.path) : null;

    if (croppedImage != null) {
      setState(() {
        imageFile = file as File;
      });
    }
  }

  Future registerTutor() async {
    // Show a loading screen while the function runs

    String? userEmail = FirebaseAuth.instance.currentUser?.email.toString();
    bool temp = false;
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await docUser.get();
    final userdata = Users.fromJson(snapshot.data()!);
    docUser.update({'isTutor': true});
    final degreeID = degreeNumberInputController.text.trim();
    final response =
        await http.get(Uri.parse('https://www.nu.edu.pk/dv?id=$degreeID'));
    if (response.statusCode == 200) {
      var document = parse(response.body);
      if (document.getElementsByTagName("td").length > 0) {
        temp = true;
      }
    }

    final addTutor =
        FirebaseFirestore.instance.collection('tutors').doc(userEmail);

    if (imageFile != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("degreeDocuments")
          .child(userEmail!)
          .putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      imgURL = await taskSnapshot.ref.getDownloadURL();
    }

    for (int i = 0; i < selectedSubjects.length; i++) {
      if (selectedSubjects[i]) {
        String subject = potentialSubjects[i];
        String price = priceControllers[i].text;
        subjectPrices[subject] = double.parse(price);
      }
    }

    for (int i = 0; i < selectedSubjects.length; i++) {
      if (selectedSubjects[i]) {
        String subject = potentialSubjects[i];
        String time = timeControllers[i].text;
        subjectTimings[subject] = time;
      }
    }
    daysOfWeek.clear();
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        String days = potentialDays[i];
        daysOfWeek.add(days);
      }
    }

    

    final tutor = Tutors(
      fullName: userdata.fullName,
      dateOfBirth: userdata.dateOfBirth,
      email: userEmail!,
      gender: userdata.gender,
      address: userdata.address,
      qualification: dropdownValue!,
      degreeNumber: degreeNumberInputController.text.trim(),
      tutoringMode: _groupValue,
      currentEmployment: employmentInputController.text.trim(),
      yearsOfExperience: int.parse(experienceInputController.text.trim()),
      degreeDocument: imgURL,
      noOfReviews: 0,
      rating: 0,
      isVerified: temp,
      prices: subjectPrices,
      timings: subjectTimings,
      daysOfWeek: daysOfWeek,
      profilePicture: userdata.profilePicture!,
      inContract: false,
      contractedStudents: {},
      isVolunteer: false,
    );

    final json = tutor.toJson();
    await addTutor.set(json);

    Navigator.of(context, rootNavigator: true).pop();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Application Submitted')),
          content: Text(
              "Thank you for submitting your tutor application. To complete the process, you'll have to log back in to your account. "),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                CustomStream.client.disconnectUser();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }

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
          'Become a tutor',
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
                'assets/images/become-a-tutor2.png',
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              SizedBox(
                height: 5,
              ),

              //Select highest qualification
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  const Text(
                    'Highest Qualification ',
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
                height: 10,
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: isQualificationSelected ? dropdownValue : null,
                    hint: Text(
                      'Select Qualification',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    dropdownColor: Colors.white,
                    icon: Icon(
                      Icons.expand_more,
                      color: Colors.grey,
                    ),
                    items: <String>[
                      'Matric',
                      'Intermediate',
                      'Bachelors',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        isQualificationSelected = true;
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),

              //Enter degree number
              Visibility(
                  visible: dropdownValue == 'Bachelors',
                  child: Column(children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        const Text(
                          'Enter degree number ',
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
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black),
                        controller: degreeNumberInputController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        const Text(
                          'Upload scanned image of degree ',
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
                      height: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Color(0xFF20464E),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                selectImage(ImageSource.camera);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromARGB(255, 162, 239, 254),
                                ),
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.73,
                                  MediaQuery.of(context).size.height * 0.06,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 162, 239, 254)),
                                ),
                              ),
                              child: Text(
                                'Upload image from camera',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Righteous',
                                  color: Color(0xFF20464E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: Color(0xFF20464E),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                selectImage(ImageSource.gallery);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromARGB(255, 162, 239, 254),
                                ),
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.73,
                                  MediaQuery.of(context).size.height * 0.06,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 162, 239, 254)),
                                ),
                              ),
                              child: Text(
                                'Upload image from gallery',
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
                    SizedBox(
                      height: 30,
                    ),
                  ])),

              //Subjects and their prices
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  const Text(
                    'Subject (select atleast one) ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
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
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
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
                        return Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[0],
                      onChanged: (bool? value) async {
                        if (value == false && selectedTimings[0] != null) {
                          disabledTimings.remove(selectedTimings[0]);
                          selectedTimings[0] = null;
                        }
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[1],
                      onChanged: (bool? value) async {
                        if (value == false && selectedTimings[1] != null) {
                          disabledTimings.remove(selectedTimings[1]);
                          selectedTimings[1] = null;
                        }
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[2],
                      onChanged: (bool? value) async {
                        if (value == false && selectedTimings[2] != null) {
                          disabledTimings.remove(selectedTimings[2]);
                          selectedTimings[2] = null;
                        }
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[3],
                      onChanged: (bool? value) async {
                        if (value == false && selectedTimings[3] != null) {
                          disabledTimings.remove(selectedTimings[3]);
                          selectedTimings[3] = null;
                        }
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[4],
                      onChanged: (bool? value) async {
                        if (value == false && selectedTimings[4] != null) {
                          disabledTimings.remove(selectedTimings[4]);
                          selectedTimings[4] = null;
                        }
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[5],
                      onChanged: (bool? value) async {
                        if (value == false && selectedTimings[5] != null) {
                          disabledTimings.remove(selectedTimings[5]);
                          selectedTimings[5] = null;
                        }
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
                      }),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: selectedSubjects[6],
                      onChanged: (bool? value) async {
                        if (value == false && selectedTimings[6] != null) {
                          disabledTimings.remove(selectedTimings[6]);
                          selectedTimings[6] = null;
                        }
                        setState(() {
                          selectedSubjects[6] = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
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
                          ),
                        )
                      ],
                    ),
                  ),
              if (selectedSubjects.contains(true))
                SizedBox(
                  height: 30,
                ),

              //Select teaching days
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  const Text(
                    'Select days to teach  ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
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
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade400),
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
                        return Color(0xFF4ECDE6);
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
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
                margin: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
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
                        return Color(0xFF4ECDE6);
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
              SizedBox(
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
                            border: Border.all(
                                width: 0.5, color: Color(0xFF4ECDE6)),
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
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
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

              //Years of experience
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  const Text(
                    'Experience in years ',
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
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  controller: experienceInputController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              //Enter current employment if any
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  const Text(
                    'Current employment (if any) ',
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: employmentInputController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              //Select Mode of tutoring
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
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.87,
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
                  fillColor: Color(0xFF4ECDE6),
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),

              //Submit button
              ElevatedButton(
                onPressed: () {
                  if (dropdownValue!.isNotEmpty &&
                      experienceInputController.text.isNotEmpty &&
                      selectedSubjects.contains(true) &&
                      _groupValue.isNotEmpty) {
                    registerTutor();
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
}
