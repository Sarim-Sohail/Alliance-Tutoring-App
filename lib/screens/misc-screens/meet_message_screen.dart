// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tutor_me/apis/store.dart';

class Message extends StatefulWidget {
  final MeetingStore meetingStore;
  const Message({Key? key, required this.meetingStore}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  late MeetingStore _meetingStore;
  late double widthOfScreen;
  late List<HMSRole> hmsRoles;
  TextEditingController messageTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _meetingStore = widget.meetingStore;
    getRoles();
  }

  void getRoles() async {
    hmsRoles = await _meetingStore.getRoles();
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Color(0xFF4ECDE6),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "In-call Messages",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Lato',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Observer(
                    builder: (_) {
                      if (!_meetingStore.isMeetingStarted) {
                        return const SizedBox();
                      }
                      if (_meetingStore.messages.isEmpty) {
                        return const Text(
                          'No messages',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'OpenSans',
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: _meetingStore.messages.length,
                        itemBuilder: (itemBuilder, index) {
                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _meetingStore
                                                .messages[index].sender?.name ??
                                            "",
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      formatter.format(
                                          _meetingStore.messages[index].time),
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 0,
                                  ),
                                  child: Text(
                                    _meetingStore.messages[index].message
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            color: Color(0xFF20464E),
                            thickness: 0.8,
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  color: Color.fromARGB(255, 228, 225, 225),
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0, left: 5.0),
                        child: TextField(
                          style: TextStyle(
                            color: Color.fromARGB(255, 86, 85, 85),
                          ),
                          autofocus: true,
                          controller: messageTextController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Send a message to everyone",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        width: widthOfScreen - 45.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          String message = messageTextController.text;
                          if (message.isEmpty) return;
                          _meetingStore.sendBroadcastMessage(message);
                          messageTextController.clear();
                        },
                        child: const Icon(
                          Icons.send,
                          size: 30.0,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

void chatMessages(BuildContext context, MeetingStore meetingStore) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (ctx) => Message(meetingStore: meetingStore),
    isScrollControlled: true,
  );
}
