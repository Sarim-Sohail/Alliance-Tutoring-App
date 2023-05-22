// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, sized_box_for_whitespace, avoid_unnecessary_containers, unnecessary_this, sort_child_properties_last, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_me/services/user_auth.dart';
import 'package:tutor_me/screens/account-screens/acc_reset_password_screen.dart';
// import 'package:tutor_me/utilities/dialogs.dart';
// import 'package:tutor_me/widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth auth = Auth();
  bool? value = false;
  Future signIn(SharedPreferences sp) async {
    print(sp.getBool('_isRemember'));
    // Check if email or password field is empty
    if (emailController.text.isEmpty || pwdController.text.isEmpty) {
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text('Empty fields'),
              content: const Text("Please enter both email and password."),
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
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            )),
      );
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: pwdController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/verify'); //verify
    }
    //Handle user credentials exceptions
    on FirebaseAuthException catch (e) {
      //Show error if user does not exist
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text('Unknown user'),
                content:
                    const Text("No user is registered with the provided email"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(14.w),
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
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              )),
        );
      }
      //Show error if invalid email or password entered
      else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: const Text('Invalid credentials'),
                content: const Text(
                    "Incorrect email or password entered. Please enter again."),
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

  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool _isObscure = true;
  bool temp = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    pwdController.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context, builder: (context) => exit(0))) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 280.h,
                width: 360.w,
                color: Color(0xFF4ECDE6),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20.w, top: 230.h),
                      child: Text(
                        "Login ",
                        style: TextStyle(
                          fontSize: 35.sp,
                          fontFamily: 'Cabin',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 90.w),
                      height: 1200.h,
                      width: 360.w,
                      child: Image.asset(
                        'assets/images/login-triangles.png',
                        fit: BoxFit.fill,
                        height: 1200.h,
                        width: 720.w,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    "Email Address",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'Cabin',
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: 325.w,
                height: 50.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.75.w,
                  ),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: 15.sp,
                  ),
                  controller: emailController,
                  obscureText: false,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'Cabin',
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: 325.w,
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.75.w,
                  ),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: 15.sp,
                  ),
                  controller: pwdController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                    icon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.grey,
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Colors.grey;
                            },
                          ),
                          value: this.value,
                          onChanged: (bool? value) async {
                            setState(() {
                              this.value = value;
                              temp = this.value!;
                            });
                          },
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'OpenSans',
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Lato',
                        color: Color(0xFF4ECDE6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ResetPassword();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final sp = await SharedPreferences.getInstance();
                      sp.setBool('_isRemember', temp);
                      print(sp.getBool('_isRemember'));
                      signIn(sp);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF60D2E9),
                      minimumSize: Size(
                        180.w,
                        50.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        side: const BorderSide(color: Color(0xFF4ECDE6)),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontFamily: 'Righteous',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 120.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'OpenSans',
                      fontSize: 15.sp,
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Register now',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Lato',
                        color: Color(0xFF4ECDE6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/registration');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
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
