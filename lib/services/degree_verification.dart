// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_me/models/degree_model.dart';

class TutorResult extends StatefulWidget {
  const TutorResult({super.key});

  @override
  State<TutorResult> createState() => _TutorResultState();
}

Future<Degree> fetchDegree(String degreeID) async {
  final response = await http
      .get(Uri.parse('https://www.nu.edu.pk/dv?id=$degreeID'));

  print('https://www.nu.edu.pk/dv?id=$degreeID');
  if (response.statusCode == 200) {
    var document=parse(response.body);
    print(document.getElementsByTagName("td").length);
    return Degree.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Degree');
  }
}

class _TutorResultState extends State<TutorResult> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    
    final futureDegree = fetchDegree(arguments['degreeID']);

    return Scaffold(
      body: FutureBuilder<Degree>(
        future: futureDegree,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.title);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
    
  }
}
