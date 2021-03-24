import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interval_timer/screens/hiit_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async{
  // Initialize notification settings
  WidgetsFlutterBinding.ensureInitialized();

  // Android app icon
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification:
        (int id, String title, String body, String payload) async{});

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint("Notification Payload : $payload");
      }
    }
  );

  // Ensure portrait orientation is locked
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(HiitApp()));
}

class HiitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIITme Interval Timer',
      home: HiitScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Function to format the time
String formatTime(Duration duration) {
  String minutes = (duration.inMinutes).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}