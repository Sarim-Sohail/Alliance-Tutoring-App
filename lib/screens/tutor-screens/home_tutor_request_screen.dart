import 'package:flutter/material.dart';

class ViewTutorRequestsScreen extends StatefulWidget {
  const ViewTutorRequestsScreen({super.key});

  @override
  State<ViewTutorRequestsScreen> createState() =>
      _ViewTutorRequestsScreenState();
}

class _ViewTutorRequestsScreenState extends State<ViewTutorRequestsScreen> {
  bool maths = false;
  bool physics = false;
  bool chemistry = false;
  bool biology = false;
  bool computerScience = false;
  bool urdu = false;
  bool english = false;
  bool? value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Requests'),
      ),
    );
  }
}
