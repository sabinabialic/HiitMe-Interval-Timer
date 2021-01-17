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