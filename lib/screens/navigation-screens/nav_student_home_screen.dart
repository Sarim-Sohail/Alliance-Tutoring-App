// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutor_me/screens/misc-screens/home_sidebar_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({
    super.key,
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65.h,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15.r),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.black,
              ),
              child: Container(
                height: 90.h,
                width: 60.w,
                child: Image.asset('assets/images/profile.png'),
              ),
            ),
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.black,
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Image.asset('assets/images/menu.png'),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: DashboardDrawer(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15.w),
                  Text(
                    'Hey there!',
                    style: TextStyle(
                      fontFamily: 'Cabin',
                      fontSize: 30.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: 35.h,
              ),
              SizedBox(
                width: 330.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/view-tutors');
                  },
                  child: Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF4ECDE6),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFF4ECDE6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 105.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Search for Tutors',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 115.h,
                          width: 100.w,
                          child: Image.asset(
                            'assets/images/look-for-tutors.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 330.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/become-tutor');
                  },
                  child: Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF3EA4B8),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: Color(0xFF3EA4B8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 125.h,
                          width: 120.w,
                          child: Image.asset(
                            'assets/images/become-a-tutor.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          height: 105.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Become a Tutor',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 330.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/contract-status-screen');
                  },
                  child: Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF2F7B8A),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: Color(0xFF2F7B8A),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 105.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'View Contracts',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 125.h,
                          width: 125.w,
                          child: Image.asset(
                            'assets/images/view-contracts.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: 330.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/request-volunteer-screen');
                  },
                  child: Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF1F525C),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xFF1F525C),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 115.h,
                          width: 105.w,
                          child: Image.asset(
                            'assets/images/request-tutor.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          height: 105.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Request a Volunteer',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
