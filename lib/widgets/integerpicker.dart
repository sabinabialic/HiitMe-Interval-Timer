import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class IntegerPicker extends StatefulWidget {
  final int initialIntegerValue;
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  IntegerPicker({
    @required this.initialIntegerValue,
    this.title,
    Widget confirmWidget,
    Widget cancelWidget
  }) : confirmWidget = confirmWidget ?? new Text(
        'OK', style: TextStyle(fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple)),
      cancelWidget = cancelWidget ?? new Text(
        'CANCEL', style: TextStyle(fontSize: 16, fontFamily: "Roboto", color: Colors.deepPurple));

  @override
  State<StatefulWidget> createState() => new _IntegerPickerState(initialIntegerValue);
}

class _IntegerPickerState extends State<IntegerPicker> {
  int initInt;

  // Constructor
  _IntegerPickerState(int initialIntegerValue) {initInt = initialIntegerValue;}

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: widget.title,
      content: new NumberPicker.integer(
          initialValue: initInt, minValue: 1, maxValue: 20,
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
          selectedTextStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06, color: Colors.purple),
          // When the value changes, the state needs to be updated
          onChanged: (value) { this.setState(() { initInt = value; }); }
      ),

      actions: [
        // If the user clicks cancel, go back to the main page
        new TextButton(onPressed: () => Navigator.of(context).pop(),
            child: widget.cancelWidget),
        // If the user clicks ok, the new value needs to be updated
        new TextButton(onPressed: () => Navigator.of(context).pop(
          // Return the int value
          initInt
        ), child: widget.confirmWidget)
      ],
    );
  }
}