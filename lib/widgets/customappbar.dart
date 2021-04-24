import 'package:flutter/material.dart';

Widget CustomAppBar(context){
  return AppBar(
    centerTitle: true, title: Text("Interval Timer",
      textAlign: TextAlign.center, style: TextStyle(fontFamily: "Roboto",
          fontSize: MediaQuery.of(context).size.width * 0.07)),
    elevation: 0.0, backgroundColor: Colors.transparent
  );
}