// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, unused_import, use_build_context_synchronously, unnecessary_new, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:tutor_me/models/user_data_model.dart';
import 'package:tutor_me/utilities/dialogs.dart';
import '../../utilities/addresses.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final dateinputController = TextEditingController();
  final addressController = TextEditingController();
  final pwdController = TextEditingController();
  final repwdController = TextEditingController();
  final genderController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final List<String> addresses = karachiAreas;

  @override
  void initState() {
    dateinputController.text = "";
    super.initState();
  }

  Future registerUser() async {
    //Check if any field is left empty
    if (emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        dateinputController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        pwdController.text.isNotEmpty &&
        genderController.text.isNotEmpty) {
      //Check if passwords match
      if (passwordConfirm()) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: pwdController.text.trim(),
          );

          addUser(
            nameController.text.trim(),
            emailController.text.trim(),
            dateinputController.text.trim(),
            addressController.text.trim(),
            genderController.text.trim(),
          );

          Navigator.pushReplacementNamed(context, '/verify');
        }
        //Handle user credentials exceptions
        on FirebaseAuthException catch (e) {
          //Check if user has entered a weak password
          if (e.code == 'weak-password') {
            showDialog(
              context: context,
              builder: ((context) => AlertDialog(
                    title: const Text('Weak password'),
                    content: const Text(
                        "The password entered is too weak. Please enter a stronger password"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: const Text(
                            "Okay",
                            style: TextStyle(
                              color: Color(0xFF112F35),
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 162, 239, 254),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }
          //Check if user already exists with the given email
          else if (e.code == 'email-already-in-use') {
            showDialog(
              context: context,
              builder: ((context) => AlertDialog(
                    title: const Text('Account already exists'),
                    content: const Text(
                        "A user account already exists with the provided email. Please use a different email"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: const Text(
                            "Okay",
                            style: TextStyle(
                              color: Color(0xFF112F35),
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 162, 239, 254),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }
        }
      }
      //Display error if passwords do not match
      else {
        showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text('Passwords do not match'),
                content: const Text("Entered passwords do not match."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      child: const Text(
                        "Okay",
                        style: TextStyle(
                          color: Color(0xFF112F35),
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 162, 239, 254),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )),
        );
      }
    }
    //Display error if any field has been left empty
    else {
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text('Empty fields'),
              content: const Text("Please enter all user details."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: const Text(
                      "Okay",
                      style: TextStyle(
                        color: Color(0xFF112F35),
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 162, 239, 254),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            )),
      );
    }
  }

  Future addUser(String fullName, String email, String dateOfBirth,
      String address, String gender) async {
    final userAdd = FirebaseFirestore.instance.collection('users').doc(email);
    List<String> conversations = <String>[];

    final user = Users(
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        address: address,
        email: email,
        gender: gender,
        isTutor: false,
        conversations: conversations);

    final json = user.toJson();
    await userAdd.set(json);
  }

  bool passwordConfirm() {
    if (pwdController.text.trim() == repwdController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    pwdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: GestureDetector(
          onTap: (() {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 1,
                          color: Color(0xFF4ECDE6),
                          child: Container(
                            margin: EdgeInsets.only(left: 260, top: 240),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Cabin',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 1.5,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Image.asset(
                            'assets/images/register-triangles.png',
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height * 1.5,
                            width: MediaQuery.of(context).size.width * 1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40, left: 5),
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.back,
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
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
                      Text(
                        "Full name",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Cabin',
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.13,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                      ),
                      cursorColor: Colors.grey,
                      controller: nameController,
                      obscureText: false,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
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
                      Text(
                        "Email address",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Cabin',
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.13,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: emailController,
                      obscureText: false,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 15,
                        ),
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
                      Text(
                        "Gender",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Cabin',
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.13,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownSearch<String>(
                      dropdownButtonProps: const DropdownButtonProps(
                          color: Colors.grey, icon: Icon(Icons.expand_more)),
                      popupProps: PopupProps.menu(
                        constraints: const BoxConstraints(
                          maxHeight: 170,
                        ),
                        showSelectedItems: true,
                        menuProps: MenuProps(
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      items: const ['Male', 'Female', 'Rather not specify'],
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        baseStyle: TextStyle(color: Colors.grey),
                        dropdownSearchDecoration: InputDecoration(
                          icon: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      onChanged: ((value) {
                        genderController.text = value as String;
                      }),
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
                      Text(
                        "Date of birth",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Cabin',
                          fontSize: 17,
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
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1975),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          DateTime currentDate = DateTime.now();
                          int age = currentDate.year - pickedDate.year;
                          if (currentDate.month < pickedDate.month ||
                              (currentDate.month == pickedDate.month &&
                                  currentDate.day < pickedDate.day)) {
                            age--;
                          }
                          if (age >= 13) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              dateinputController.text = formattedDate;
                            });
                          } else {
                            // Display an error message to the user
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      "Sorry, you must be at least 13 years old to sign up.",
                                      style: TextStyle(
                                          fontSize: 16, fontFamily: "OpenSans"),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      controller: dateinputController,
                      obscureText: false,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.date_range_outlined,
                          color: Colors.grey,
                        ),
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
                      Text(
                        "Address",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Cabin',
                          fontSize: 17,
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
                    child: DropdownSearch<String>(
                      popupProps: PopupProps.dialog(
                        showSelectedItems: true,
                        showSearchBox: true,
                        dialogProps: DialogProps(
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Colors.grey),
                            hintText: 'Search for areas',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      dropdownButtonProps: DropdownButtonProps(
                          icon: Icon(
                        Icons.expand_more,
                        color: Colors.grey,
                      )),
                      items: addresses,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Address",
                          icon: Icon(
                            Icons.home_outlined,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      onChanged: ((value) {
                        addressController.text = value as String;
                      }),
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
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Cabin',
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.13,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                      ),
                      controller: pwdController,
                      obscureText: true,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
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
                      Text(
                        "Confirm password",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Cabin',
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.13,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 15,
                      ),
                      controller: repwdController,
                      cursorColor: Colors.grey,
                      obscureText: true,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF60D2E9),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.5,
                        50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Color(0xFF4ECDE6)),
                      ),
                    ),
                    child: Text(
                      'Create',
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Righteous',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
