// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, avoid_unnecessary_containers, unused_import, unused_local_variable, body_might_complete_normally_nullable, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_me/models/user_data_model.dart';
import 'package:tutor_me/utilities/stream.dart';
import '../../utilities/addresses.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final dateinputController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final List<String> addresses = karachiAreas;

  Future<Users?> readUser() async {
    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    String userEmail = uEmail.toString();
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return Users.fromJson(snapshot.data()!);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  File? imageFile;

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile xFile) async {
    ImageCropper imageCropper =
        ImageCropper(); // create an instance of ImageCropper
    CroppedFile? croppedImage = await imageCropper.cropImage(
        sourcePath: xFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20,
        cropStyle: CropStyle.circle);
    File? file = croppedImage?.path != null ? File(croppedImage!.path) : null;

    if (croppedImage != null) {
      setState(() {
        imageFile = file as File;
      });
    }
  }

  void showImageOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Upload profile picture",
              style: TextStyle(
                color: Colors.grey.shade700, 
                fontFamily: 'OpenSans',
                fontSize: 17,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.gallery);
                    },
                    leading: Icon(
                      Icons.photo_album,
                      color: Colors.grey,
                    ),
                    title: Text(
                      "Select from gallery",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'OpenSans',
                        fontSize: 17,
                      ),
                    )),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt_outlined, color: Colors.grey),
                  title: Text(
                    "Take a photo",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'OpenSans',
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void uploadFile(String email) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilePictures")
        .child(email)
        .putFile(imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imgURL = await taskSnapshot.ref.getDownloadURL();
    // print(imgURL);

    FirebaseFirestore.instance.collection('users').doc(email).update({
      'profilePicture': imgURL,
    });
    FirebaseFirestore.instance.collection('tutors').doc(email).update({
      'profilePicture': imgURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    String userEmail = uEmail.toString();
    String fullName = '';

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text(
        //   'Profile',
        //   style: TextStyle(
        //     color: Colors.white,
        //     fontFamily: 'Lato',
        //     fontSize: 23,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 29, 84, 96),
                Color(0xFF173d45),
              ],
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              CustomStream.client.disconnectUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(Icons.logout_outlined),
            iconSize: 30,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Users?>(
        future: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data;
            return users == null ? Text("No Data") : displayUser(users);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget displayUser(Users users) {
    bool hasUpdated = false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF4ECDE6),
                    Color.fromARGB(255, 28, 82, 93),
                  ],
                ),
              ),
              child: null,
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.725,
                      width: MediaQuery.of(context).size.width * 0.94,
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
                            height: MediaQuery.of(context).size.height * 0.09,
                          ),
                          //Full name field
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text(
                                'Full Name',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: nameController,
                              obscureText: false,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                suffixIconColor: Colors.black87,
                                hintText: users.fullName,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //Email address field

                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              readOnly: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: users.email,
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //DOB field

                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text(
                                'Date of Birth',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              readOnly: true,
                              style: TextStyle(color: Colors.black),
                              controller: dateinputController,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
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
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
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
                                              "Sorry, you can't modify your date of birth to be under 13 years old.",
                                              textAlign: TextAlign.center,
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
                              obscureText: false,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                suffixIconColor: Colors.black87,
                                hintText: DateFormat('dd-MM-yyyy')
                                    .format(DateTime.parse(users.dateOfBirth)),
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //Gender field

                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text(
                                'Gender',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                constraints: BoxConstraints(
                                  maxHeight: 170,
                                ),
                                showSelectedItems: true,
                                menuProps: MenuProps(
                                  backgroundColor: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 0.7,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              items: ['Male', 'Female', 'Rather not specify'],
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                baseStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                dropdownSearchDecoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: users.gender,
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              dropdownButtonProps: DropdownButtonProps(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                              onChanged: ((value) {
                                genderController.text = value as String;
                              }),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //Address field

                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Text(
                                'Address',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.05,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.dialog(
                                showSelectedItems: true,
                                showSearchBox: true,
                                dialogProps: DialogProps(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey, width: 0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.search),
                                    hintText: 'Search for areas',
                                    hintStyle: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              items: addresses,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                baseStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: users.address,
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                              dropdownButtonProps: DropdownButtonProps(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 20,
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

                          //SAVE Button

                          ElevatedButton(
                            onPressed: () {
                              if (imageFile != null) {
                                uploadFile(users.email);
                                hasUpdated = true;
                              }
                              final docUser = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(users.email);

                              if (addressController.text.isNotEmpty) {
                                docUser.update({
                                  'address': addressController.text.trim(),
                                });
                                addressController.clear();
                                hasUpdated = true;
                              }
                              if (nameController.text.isNotEmpty) {
                                docUser.update({
                                  'fullName': nameController.text.trim(),
                                });
                                nameController.clear();
                                hasUpdated = true;
                              }
                              if (genderController.text.isNotEmpty) {
                                docUser.update({
                                  'gender': genderController.text.trim(),
                                });
                                genderController.clear();
                                hasUpdated = true;
                              }
                              if (dateinputController.text.isNotEmpty) {
                                docUser.update({
                                  'dateOfBirth':
                                      dateinputController.text.trim(),
                                });
                                dateinputController.clear();
                                hasUpdated = true;
                              }
                              if (hasUpdated) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Profile updated',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato',
                                        fontSize: 17,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.grey,
                                    behavior: SnackBarBehavior.floating,
                                    dismissDirection: DismissDirection.vertical,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 30,
                                    margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height -
                                              130,
                                      left: 130,
                                      right: 130,
                                    ),
                                  ),
                                );
                                hasUpdated = false;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF60D2E9),
                              minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.47,
                                MediaQuery.of(context).size.height * 0.06,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side:
                                    const BorderSide(color: Color(0xFF60D2E9)),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: const TextStyle(
                                fontSize: 24,
                                fontFamily: 'Righteous',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Ⓒ Copyrights 2022, All rights reserved.\n                    Made in Pakistan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: (users.profilePicture != "")
                            ? NetworkImage(users.profilePicture!)
                            : null,
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        child: (users.profilePicture == "")
                            ? Image.asset(
                                'assets/images/user-image.png',
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width * 0.3,
                              )
                            : null,
                      ),
                      onPressed: () {
                        showImageOptions();
                      },
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
