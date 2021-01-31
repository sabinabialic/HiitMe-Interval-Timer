import 'package:flutter/material.dart';
import 'package:interval_timer/screens/hiit_screen.dart';

void main() async{
  // TODO: Initialize notification settings

  runApp(HiitApp());
}

class HiitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIIT Timer',
      home: HiitScreen(),
    );
  }
}

// Function to format the time
String formatTime(Duration duration) {
  String minutes = (duration.inMinutes).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}