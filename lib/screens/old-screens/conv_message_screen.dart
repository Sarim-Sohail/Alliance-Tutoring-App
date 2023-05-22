// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, unused_import, use_build_context_synchronously, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:tutor_me/models/message_model.dart';
import 'package:tutor_me/screens/contract-screens/contract_draft_screen.dart';
import 'package:uuid/uuid.dart';
import '../../models/room_model.dart';
import '../../models/user_chat_model.dart';
import 'package:tutor_me/models/user_data_model.dart';

import '../../utilities/icons.dart';

var uuid = Uuid();

class MessageScreen extends StatefulWidget {
  final RoomModel roomModel;
  final UserModel targetUser;
  final UserModel userModel;
  final User firebaseUser;

  const MessageScreen(
      {super.key,
      required this.roomModel,
      required this.targetUser,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageController = TextEditingController();

  void sendContract() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Contract'),
          content: Text(
              'Are you sure you want to send a contract to ${widget.targetUser.fullName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
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
        MaterialPageRoute(builder: (context) => DraftContract(email: widget.targetUser.email as String)),
      );
    }
  }

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    String userEmail = uEmail.toString();
    final docUser = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();
    final currData = docUser.data() as Map<String, dynamic>;

    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageID: uuid.v1(),
        sender: currData['email'],
        sentAt: DateTime.now(),
        text: msg,
        isSeen: false,
      );
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.roomModel.roomID)
          .collection('messages')
          .doc(newMessage.messageID)
          .set(newMessage.toJson());
      widget.roomModel.lastMessage = msg;
      widget.roomModel.lastMessageSent = DateTime.now();

      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.roomModel.roomID)
          .set(widget.roomModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.argument);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF4ECDE6),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: widget.targetUser.profilePicture != ""
                  ? NetworkImage(widget.targetUser.profilePicture!)
                  : null,
              child: widget.targetUser.profilePicture == ""
                  ? Icon(
                      Icons.person_outline,
                      color: Color(0xFF4ECDE6),
                      size: 30,
                    )
                  : null,
            ),
            SizedBox(width: 10),
            Text(
              widget.targetUser.fullName!,
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(
            onPressed: () {
              sendContract();
            },
            icon: Icon(CustomIcons.icons8_signing_a_document_96),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(widget.roomModel.roomID)
                          .collection('messages')
                          .orderBy('sentAt', descending: true)
                          .snapshots(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            QuerySnapshot dataSnapshot =
                                snapshot.data as QuerySnapshot;
                            return ListView.builder(
                                reverse: true,
                                itemCount: dataSnapshot.docs.length,
                                itemBuilder: ((context, index) {
                                  MessageModel currMessage =
                                      MessageModel.fromJson(
                                          dataSnapshot.docs[index].data()
                                              as Map<String, dynamic>);

                                  return Wrap(
                                    alignment: (currMessage.sender ==
                                            widget.targetUser.email)
                                        ? WrapAlignment.start
                                        : WrapAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: (currMessage.sender ==
                                                    widget.targetUser.email)
                                                ? Colors.grey.shade200
                                                : Color(0xFF4ECDE6),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Wrap(children: [
                                              Text(
                                                currMessage.text.toString(),
                                                style: (currMessage.sender ==
                                                        widget.targetUser.email)
                                                    ? TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Lato',
                                                        fontSize: 15,
                                                        overflow: TextOverflow
                                                            .visible)
                                                    : TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Lato',
                                                        fontSize: 15,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                maxLines: null,
                                              ),
                                            ]),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              height: 20,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    DateFormat('h:mm a').format(
                                                        currMessage.sentAt!),
                                                    textAlign: TextAlign.right,
                                                    style: (currMessage
                                                                .sender ==
                                                            widget.targetUser
                                                                .email)
                                                        ? TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Lato',
                                                            fontSize: 10,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible)
                                                        : TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: 'Lato',
                                                            fontSize: 10,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible),
                                                    maxLines: null,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }));
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("An error has occurred"),
                            );
                          } else {
                            return Center(
                              child: Text("Send a message"),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextField(
                                maxLines: null,
                                controller: messageController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Message",
                                  hintStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CustomIcons.icons8_attach_96,
                                color: Color(0xFF4ECDE6),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                sendContract();
                              },
                              icon: Icon(
                                CustomIcons.icons8_camera_96,
                                color: Color(0xFF4ECDE6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFF4ECDE6),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
