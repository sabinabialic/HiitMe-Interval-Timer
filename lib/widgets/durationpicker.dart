import 'package:flutter/cupertino.dart';

// Widget obtained from https://pub.dev/packages/numberpicker
import 'package:numberpicker/numberpicker.dart';

class DurationPicker extends StatefulWidget {
  final Duration initDuration;
  final Widget confirmWidget;
  final Widget cancelWidget;

  DurationPicker({
    @required this.initDuration,
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
    // TODO: implement build
    throw UnimplementedError();
  }
}