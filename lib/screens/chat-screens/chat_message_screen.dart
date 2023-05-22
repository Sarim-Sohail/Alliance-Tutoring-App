// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tutor_me/utilities/icons.dart';

import '../contract-screens/contract_draft_screen.dart';

class ChannelPage extends StatefulWidget {
  final String targetEmail;
  const ChannelPage({
    required this.targetEmail,
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  bool emailExists = false;
  @override
  void initState() {
    super.initState();
    checkEmailExists();
  }

  Future<void> checkEmailExists() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tutors')
        .where('email', isEqualTo: widget.targetEmail)
        .get();

    setState(() {
      emailExists = snapshot.size > 0;
    });
  }

  void sendContract() async {
    var fullName = '';
    await FirebaseFirestore.instance
        .collection('tutors')
        .where('email', isEqualTo: widget.targetEmail)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size > 0) {
        final tutorData = snapshot.docs.first.data() as Map<String, dynamic>;
        fullName = tutorData['fullName'] as String;

        // Use the fullName in your logic
      }
    });

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Send Contract'),
          content:
              Text('Are you sure you want to send a contract to $fullName?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DraftContract(email: widget.targetEmail)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StreamChannelHeader(
        backgroundColor: const Color(0xFF4ECDE6),
        actions: [
          emailExists ? IconButton(
            onPressed: () {
              sendContract();
            },
            icon: const Icon(CustomIcons.icons8_signing_a_document_96),
          ) : Container(),
        ],
      ),
      body: const Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
