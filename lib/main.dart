// ignore_for_file: unused_import, duplicate_import, library_prefixes, prefer_const_constructors, avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tutor_me/models/user_data_model.dart';
import 'package:tutor_me/screens/navigation-screens/nav_conversation_screen.dart';
import 'package:tutor_me/screens/volunteer-screens/home_student_request_volunteer_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_list_display_filters_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_middleground_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_profile_screen.dart';
import 'package:tutor_me/screens/volunteer-screens/home_tutor_view_volunteer_filters_screen.dart';
import 'package:tutor_me/screens/volunteer-screens/home_tutor_view_volunteer_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_view_contracts_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_contract_screen.dart';
import 'package:tutor_me/screens/volunteer-screens/home_become_volunteer_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_view_students_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_become_screen.dart';
import 'package:tutor_me/screens/account-screens/acc_login_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_dashboard_screen.dart';
import 'package:tutor_me/screens/navigation-screens/nav_meeting_screen.dart';
import 'package:tutor_me/screens/student-screens/home_student_profile_screen.dart';
import 'package:tutor_me/screens/account-screens/acc_registration_screen.dart';
import 'package:tutor_me/screens/misc-screens/home_settings_screen.dart';
import 'package:tutor_me/screens/init-screens/init_splash_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_view_detail_screen.dart';
import 'package:tutor_me/screens/account-screens/acc_verify_screen.dart';
import 'package:tutor_me/screens/tutor-screens/home_tutor_list_display_screen.dart';
import 'package:tutor_me/screens/old-screens/nav_conversation_screen.dart';
import 'package:tutor_me/screens/welcome-screens/welcome_screen_2.dart';
import 'package:tutor_me/screens/welcome-screens/welcome_screen_3.dart';
import 'package:tutor_me/screens/welcome-screens/welcome_screen_4.dart';
import 'package:tutor_me/screens/welcome-screens/welcome_screen_4.dart';
import 'package:tutor_me/screens/welcome-screens/welcome_screen_5.dart';
import 'package:tutor_me/screens/welcome-screens/welcome_screen_1.dart';
import 'package:tutor_me/utilities/stream.dart';
import 'screens/init-screens/init_auth_screen.dart';
import 'services/degree_verification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stream_chat/stream_chat.dart' as SC;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:tutor_me/utilities/stream.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  String? uEmail = FirebaseAuth.instance.currentUser?.email;
  String userEmail = uEmail.toString();
  final docUser = FirebaseFirestore.instance.collection('users').doc(userEmail);
  final snapshot = await docUser.get();
  Users user = Users.fromJson(snapshot.data()!);
  print("test");
  CustomStream.client.connectUser(
    SC.User(
      id: userEmail.replaceAll('.', '').replaceAll('@', '-'),
      name: user.fullName,
      extraData: {'email': userEmail},
    ),
    CustomStream.client
        .devToken(userEmail.replaceAll('.', '').replaceAll('@', '-'))
        .rawValue,
    connectWebSocket: true,
  );

  handleNotification(message, CustomStream.client);
}

Future<FlutterLocalNotificationsPlugin> setupLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  return flutterLocalNotificationsPlugin;
}

void handleNotification(
  RemoteMessage message,
  StreamChatClient chatClient,
) async {
  print(message.data);
  final data = message.data;

  if (data['type'] == 'message.new') {
    final flutterLocalNotificationsPlugin = await setupLocalNotifications();
    final messageId = data['id'];
    final response = await chatClient.getMessage(messageId);

    flutterLocalNotificationsPlugin.show(
      1,
      'You have a new message from ${response.message.user!.name}!',
      response.message.text,
      NotificationDetails(
          android: AndroidNotificationDetails(
        'new_message',
        'New message notifications channel',
      )),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        rebuildFactor: RebuildFactors.all,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return StreamChat(
                  streamChatThemeData: StreamChatThemeData(
                    primaryIconTheme: IconThemeData(size: 15, color: Colors.white),
                    messageInputTheme: StreamMessageInputThemeData(
                      borderRadius: BorderRadius.circular(10.r),
                      activeBorderGradient: LinearGradient(
                          colors: const [Color(0xFF4ECDE6), Color(0xFF4ECDE6)]),
                      expandButtonColor: Color(0xFF4ECDE6),
                      linkHighlightColor: Color(0xFF4ECDE6),
                      inputTextStyle: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'OpenSans',
                          fontSize: 15.sp),
                      actionButtonColor: Color(0xFF4ECDE6),
                      sendButtonColor: Color(0xFF4ECDE6),
                      actionButtonIdleColor: Color(0xFF4ECDE6),
                      sendButtonIdleColor: Color(0xFF4ECDE6),
                    ),
                    brightness: Brightness.light,
                    textTheme: StreamTextTheme.light(),
                    channelPreviewTheme: StreamChannelPreviewThemeData(
                      unreadCounterColor: Color(0xFF4ECDE6),
                      subtitleStyle: TextStyle(
                          color: const Color.fromARGB(255, 112, 111, 111),
                          fontFamily: 'OpenSans',
                          fontSize: 13.sp),
                      lastMessageAtStyle: TextStyle(
                          color: Color(0xFF4ECDE6),
                          fontFamily: 'OpenSans',
                          fontSize: 12.sp),
                      titleStyle: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'OpenSans',
                          fontSize: 15.sp),
                    ),
                    channelHeaderTheme: StreamChannelHeaderThemeData(
                        titleStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Lato',
                            fontSize: 15.sp),
                        subtitleStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Lato',
                            fontSize: 13.sp)),
                    otherMessageTheme: StreamMessageThemeData(
                      messageBackgroundColor: Colors.grey.shade200,
                      messageTextStyle: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'OpenSans',
                          fontSize: 15.sp),
                    ),
                    ownMessageTheme: StreamMessageThemeData(
                      messageBackgroundColor: Color(0xFF4ECDE6),
                      messageTextStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 15.sp),
                    ),
                  ),
                  client: CustomStream.client,
                  child: child);
            },
            title: 'Alliance',
            routes: {
              '/welcome-screen-1': (context) => const WelcomeScreen1(),
              '/welcome-screen-2': (context) => const WelcomeScreen2(),
              '/welcome-screen-3': (context) => const WelcomeScreen3(),
              '/welcome-screen-4': (context) => const WelcomeScreen4(),
              '/welcome-screen-5': (context) => const WelcomeScreen5(),
              '/splash-screen': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/main': (context) => const MainScreen(),
              '/registration': (context) => const RegistrationScreen(),
              '/become-tutor': (context) => const BecomeTutor(),
              '/view-tutors': (context) => const ViewTutors(),
              '/view-students': (context) => const ViewStudents(),
              '/tutor-detail': (context) => const TutorDetail(),
              '/tutor-result': (context) => const TutorResult(),
              '/profile': (context) => const ProfileScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/auth-screen': (context) => const AuthScreen(),
              '/verify': (context) => const VerifyScreen(),
              '/meeting-screen': (context) => const MeetingScreen(),
              '/message-screen': (context) => const ConversationScreen(),
              '/view-volunteering-requests-screen': (context) =>
                  const ViewVolunteerRequestsScreen(),
              '/view-contracts-screen': (context) =>
                  const ViewContractsScreen(),
              '/become-volunteer-screen': (context) => const BecomeVolunteer(),
              '/request-volunteer-screen': (context) =>
                  const RequestVolunteerScreen(),
              '/contract-status-screen': (context) => const ContractStatus(),
              '/profile-nav-screen': (context) => const ProfileNavScreen(),
              '/tutor-profile-screen': (context) => const TutorProfileScreen(),
              '/view-tutors-filters-screen': (context) => const FiltersScreen(),
              '/view-requests-filters-screen': (context) =>
                  const RequestFiltersScreen(),
              '/view-conversations-screen': (context)=> ChannelListPage(client: CustomStream.client)
            },
            theme: ThemeData(
              
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color.fromRGBO(36, 36, 36, 1),
              textTheme: TextTheme(
                bodyText1: TextStyle(color: Colors.black),
                bodyText2: TextStyle(color: Colors.black),
                headline1: TextStyle(color: Colors.black),
                headline2: TextStyle(color: Colors.black),
                headline3: TextStyle(color: Colors.black),
                headline4: TextStyle(color: Colors.black),
                headline5: TextStyle(color: Colors.black),
                headline6: TextStyle(color: Colors.black),
                subtitle1: TextStyle(color: Colors.black),
                subtitle2: TextStyle(color: Colors.black),
                caption: TextStyle(color: Colors.black),
                button: TextStyle(color: Colors.black),
                overline: TextStyle(color: Colors.black),
              ),
            ),
            home: const SplashScreen(),
          );
        });
  }
}
