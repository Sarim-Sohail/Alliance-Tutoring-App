// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_constructors, unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:tutor_me/services/user_auth.dart';
import 'package:tutor_me/apis/store.dart';
import 'package:tutor_me/apis/peer.dart';
import 'package:tutor_me/screens/misc-screens/meet_message_screen.dart';
import 'package:tutor_me/models/user_data_model.dart';

class ZoomMeeting extends StatefulWidget {
  const ZoomMeeting({Key? key, required this.link}) : super(key: key);
  final String link;
  @override
  _ZoomMeetingState createState() => _ZoomMeetingState();
}

class _ZoomMeetingState extends State<ZoomMeeting> with WidgetsBindingObserver {
  final Auth auth = Auth();

  late MeetingStore mStore;
  bool handRaise = false;
  bool selfDismiss = false;

  initializeMeeting() async {
    String? uEmail = FirebaseAuth.instance.currentUser?.email;
    String userEmail = uEmail.toString();
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await docUser.get();
    Users user = Users.fromJson(snapshot.data()!);

    String? username = auth.user.displayName;
    String partoflink = 'https://tutorme.app.100ms.live/meeting/';
    final meetinglink = partoflink + widget.link;
    bool response = await mStore.join(user.fullName, meetinglink);
    // print(username.toString());
    if (!response) {
      mStore.addUpdateListener();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    mStore = MeetingStore();
    initializeMeeting();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 53, 52, 52),
        appBar: AppBar(
          title: const Text("In-call"),
          actions: [
            IconButton(
              onPressed: () {
                mStore.switchCamera();
              },
              icon: const Icon(Icons.cameraswitch_outlined),
            ),
            IconButton(
                onPressed: () {
                  chatMessages(context, mStore);
                },
                icon: const Icon(Icons.message)),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => _onBackPressed(),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Flexible(
                        child: Observer(
                          builder: (_) {
                            if (mStore.isRoomEnded && !selfDismiss) {
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/main'));
                            }
                            if (mStore.peerTracks.isEmpty) {
                              return const Center(
                                  child: Text('Waiting for others to join!'));
                            }
                            ObservableList<PeerTrackNode> peerFilteredList =
                                mStore.peerTracks;

                            return videoPageView(
                              filteredList: peerFilteredList,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Observer(builder: (context) {
                      return CircleAvatar(
                        radius: 25,
                        backgroundColor: Color.fromARGB(255, 85, 84, 84),
                        child: IconButton(
                          icon: mStore.isMicOn
                              ? const Icon(Icons.mic)
                              : const Icon(Icons.mic_off),
                          onPressed: () {
                            mStore.switchAudio();
                          },
                          color: Colors.white,
                        ),
                      );
                    }),
                    Observer(builder: (context) {
                      return CircleAvatar(
                        radius: 25,
                        backgroundColor: Color.fromARGB(255, 85, 84, 84),
                        child: IconButton(
                          icon: mStore.isVideoOn
                              ? const Icon(Icons.videocam)
                              : const Icon(Icons.videocam_off),
                          onPressed: () {
                            mStore.switchVideo();
                          },
                          color: Colors.white,
                        ),
                      );
                    }),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: handRaise
                          ? Color.fromARGB(255, 85, 84, 84)
                          : Color.fromARGB(255, 255, 255, 255),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/raise_hand.png',
                          color: handRaise ? Colors.white : Color(0xFF20464E),
                        ),
                        onPressed: () {
                          setState(() {
                            handRaise = !handRaise;
                          });
                          mStore.changeMetadata();
                        },
                        color: Colors.white,
                      ),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: const Icon(Icons.call_end),
                        onPressed: () {
                          mStore.leave();
                          selfDismiss = true;
                          Navigator.pop(context);
                        },
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        bool ans = await _onBackPressed();
        return ans;
      },
    );
  }

  Future<dynamic> _onBackPressed() {
    return showDialog(
        useRootNavigator: false,
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Leave the Meeting?',
                  style: TextStyle(fontSize: 24)),
              actions: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      mStore.leave();
                      selfDismiss = true;
                      final meetings =
                          FirebaseFirestore.instance.collection('meetings');
                      final snapshot = await meetings
                          .where('link', isEqualTo: widget.link)
                          .get();
                      if (snapshot.docs.isNotEmpty) {
                        final doc = snapshot.docs.first;
                        final data = doc.data();
                        final memberCount = (data['memberCount'] ?? 0) - 1;
                        await doc.reference
                            .update({'memberCount': memberCount});
                      }
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yes', style: TextStyle(fontSize: 24))),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child:
                        const Text('Cancel', style: TextStyle(fontSize: 24))),
              ],
            ));
  }

  Widget videoPageView({required List<PeerTrackNode> filteredList}) {
    List<Widget> pageChild = [];
    if (mStore.curentScreenShareTrack != null) {
      pageChild.add(RotatedBox(
        quarterTurns: 1,
        child: Container(
            margin:
                const EdgeInsets.only(bottom: 0, left: 0, right: 100, top: 0),
            child: Observer(builder: (context) {
              return HMSVideoView(
                  track: mStore.curentScreenShareTrack as HMSVideoTrack);
            })),
      ));
    }
    for (int i = 0; i < filteredList.length; i = i + 6) {
      if (filteredList.length - i > 5) {
        Widget temp = singleVideoPageView(6, i, filteredList);
        pageChild.add(temp);
      } else {
        Widget temp =
            singleVideoPageView(filteredList.length - i, i, filteredList);
        pageChild.add(temp);
      }
    }
    return PageView(
      children: pageChild,
    );
  }

  Widget singleVideoPageView(int count, int index, List<PeerTrackNode> tracks) {
    return Align(
        alignment: Alignment.center,
        child: Container(
            margin: const EdgeInsets.only(
                bottom: 100, left: 10, right: 10, top: 10),
            child: Observer(builder: (context) {
              return videoViewGrid(count, index, tracks);
            })));
  }

  Widget videoViewGrid(int count, int start, List<PeerTrackNode> tracks) {
    ObservableMap<String, HMSTrackUpdate> trackUpdate = mStore.trackStatus;
    return GridView.builder(
      itemCount: count,
      // physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (itemBuilder, index) {
        return Observer(builder: (context) {
          return videoTile(
              tracks[start + index],
              !(tracks[start + index].peer.isLocal
                  ? !mStore.isVideoOn
                  : (trackUpdate[tracks[start + index].peer.peerId]) ==
                      HMSTrackUpdate.trackMuted),
              MediaQuery.of(context).size.width / 2 - 25,
              tracks[start + index].isRaiseHand);
        });
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.88),
    );
  }

  Widget videoTile(
      PeerTrackNode track, bool isVideoMuted, double size, bool isHandRaised) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: size,
                height: size,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (track.track != null && isVideoMuted)
                        ? HMSVideoView(
                            track: track.track as HMSVideoTrack,
                            scaleType: ScaleType.SCALE_ASPECT_FILL)
                        : Container(
                            width: 200,
                            height: 200,
                            color: Color.fromARGB(255, 85, 84, 84),
                            child: Center(
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.green,
                                child: track.name.contains(" ")
                                    ? Text(
                                        (track.name.toString().substring(0, 1) +
                                                track.name
                                                    .toString()
                                                    .split(" ")[1]
                                                    .substring(0, 1))
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      )
                                    : Text(track.name
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase()),
                              ),
                            ))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                track.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: isHandRaised
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/raise_hand.png',
                    scale: 2,
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (mStore.isVideoOn) {
        mStore.startCapturing();
      } else {
        mStore.stopCapturing();
      }
    } else if (state == AppLifecycleState.paused) {
      if (mStore.isVideoOn) {
        mStore.stopCapturing();
      }
    } else if (state == AppLifecycleState.inactive) {
      if (mStore.isVideoOn) {
        mStore.stopCapturing();
      }
    }
  }
}
