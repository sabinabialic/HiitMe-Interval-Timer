import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Widget obtained from https://pub.dev/packages/numberpicker
import 'package:numberpicker/numberpicker.dart';

class DurationPicker extends StatefulWidget {
  final Duration initDuration;
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  DurationPicker({
    @required this.initDuration,
    this.title,
    Widget confirmWidget,
    Widget cancelWidget
  }) : confirmWidget = confirmWidget ?? new Text('Ok'),
        cancelWidget = cancelWidget ?? new Text('Cancel');

  @override
  State<StatefulWidget> createState() => new _DurationPickerState(initDuration);
}

class _DurationPickerState extends State<DurationPicker> {
  int min;
  int sec;

  // Constructor
  _DurationPickerState(Duration defaultDuration) {
    min = defaultDuration.inMinutes;
    sec = defaultDuration.inSeconds % Duration.secondsPerMinute;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: widget.title,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Number picker for minutes
          new NumberPicker.integer(
              initialValue: min,
              minValue: 0,
              maxValue: 10,
              // When the value changes, the state needs to be updated
              onChanged: (value) { this.setState(() { min = value; }); }
          ),

          // Colon separator between minutes and seconds
          Text (":", style: TextStyle(fontSize: 22)),

          // Number picker for seconds
          new NumberPicker.integer(
              initialValue: sec,
              minValue: 0,
              maxValue: 59,
              // When the value changes, the state needs to be updated
              onChanged: (value) { this.setState(() { sec = value; }); }
          ),
        ],
      ),

      actions: [
        // If the user clicks cancel, go back to the main page
        new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: widget.cancelWidget),
        // If the user clicks ok, the new values need to be updated
        new FlatButton(
            onPressed: () => Navigator.of(context).pop(
                new Duration(
                    minutes: min,
                    seconds: sec)
            ),
            child: widget.confirmWidget)
      ],
    );
  }
}