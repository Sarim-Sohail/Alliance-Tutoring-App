// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, unused_import, use_build_context_synchronously, sized_box_for_whitespace, sized_box_for_whitespace, sized_box_for_whitespace, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:tutor_me/screens/old-screens/conv_message_screen.dart';

import '../../models/room_model.dart';
import '../../models/firebase_model.dart';
import '../../models/user_chat_model.dart';

// import 'package:tutor_me/screens/messages_search_screen.dart';

class ConversationScreen extends StatefulWidget {
  final String? argument;
  final UserModel? userModel;
  final User? firebaseModel;
  const ConversationScreen(
      {Key? key, this.argument, this.userModel, this.firebaseModel})
      : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Future<RoomModel?> checkRoomModel(String targetEmail) async {
    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    String userEmail = uEmail.toString();
    // print(userEmail);
    // print(targetEmail);

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("chats").get();

    RoomModel? roomModel;
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data["participants"][userEmail] == true &&
          data["participants"][targetEmail] == true) {
        roomModel = RoomModel.fromMap(data);
        break;
      }
    }

    return roomModel;
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return DateFormat('h:mm a').format(date); // format for today
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Yesterday";
    } else {
      return DateFormat('dd/MM/yyyy').format(date); // format for other dates
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chats',
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
      body: SafeArea(
        child: Container(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .where('members', arrayContains: widget.userModel!.email)
              .orderBy('lastMessageSent', descending: true)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                // print('has data');
                QuerySnapshot chatSnapshot = snapshot.data as QuerySnapshot;
                if (chatSnapshot.docs.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.055,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 244, 244),
                          border: Border.all(
                            color: Color.fromARGB(255, 247, 244, 244),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF20464E),
                            ),
                            border: InputBorder.none,
                            hintText: 'Search or start a new chat',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: chatSnapshot.docs.length,
                          itemBuilder: ((context, index) {
                            RoomModel roomModel = RoomModel.fromMap(
                                chatSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            Map<String, dynamic> participants =
                                roomModel.participants!;
                            List<String> participantList =
                                participants.keys.toList();
                            participantList.remove(widget.firebaseModel!.email);

                            return FutureBuilder(
                                future: FirebaseHelper.getUserData(
                                    participantList[0]),
                                builder: (context, userData) {
                                  if (userData.connectionState ==
                                      ConnectionState.done) {
                                    if (userData.data != null) {
                                      UserModel targetUser =
                                          userData.data as UserModel;

                                      return GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          // print('tapping');
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return MessageScreen(
                                              roomModel: roomModel,
                                              firebaseUser:
                                                  widget.firebaseModel as User,
                                              targetUser: targetUser,
                                              userModel:
                                                  widget.userModel as UserModel,
                                            );
                                          }));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundImage: (targetUser
                                                            .profilePicture !=
                                                        "")
                                                    ? NetworkImage(targetUser
                                                        .profilePicture!)
                                                    : null,
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.white,
                                                child: (targetUser
                                                            .profilePicture ==
                                                        "")
                                                    ? Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Icon(
                                                          Icons.person_outline,
                                                          size: 40,
                                                          color:
                                                              Color(0xFF4ECDE6),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      targetUser.fullName
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Lato',
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    roomModel.lastMessage
                                                                .toString() !=
                                                            ""
                                                        ? Text(
                                                            roomModel
                                                                .lastMessage
                                                                .toString(),
                                                            style: TextStyle(
                                                              overflow: TextOverflow.ellipsis,
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 15,
                                                            ),
                                                            maxLines: 2,
                                                          )
                                                        : Text(
                                                            "Say hello",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontFamily:
                                                                  'Lato',
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.22,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                child: Text(
                                                  formatDate(roomModel
                                                      .lastMessageSent!),
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontFamily: 'Lato',
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return Container();
                                  }
                                });
                          }),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                          ),
                          const Text(
                            "No active chats!",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.13,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.height * 0.25,
                            child: Image.asset(
                                'assets/images/no-active-chats.png'),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          const Text(
                            "Staying stress-free, are we?",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              } else {
                return Center(
                  child: Container(),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        )),
      ),
    );
  }
}
