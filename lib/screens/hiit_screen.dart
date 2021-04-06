import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interval_timer/screens/workout_screen.dart';
import 'package:interval_timer/widgets/durationpicker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../main.dart';
import '../models.dart';

class HiitScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HiitScreenState();
}

class _HiitScreenState extends State<HiitScreen> {
  Hiit _hiit;

  @override
  initState() {
    _hiit = defaultHiit;
    super.initState();
  }

  // Callback for when the duration changes
  _onHiitChanged() { setState(() {}); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Interval Timer",
          style: TextStyle(fontFamily: "Roboto",
              fontSize: ResponsiveFlutter.of(context).fontSize(3.2))
        ),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        backgroundColor: Color(0xFFFFFF),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            // Background color
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Colors.purple, Colors.indigo],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                )),

            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 140, 20, 60),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(formatTime(_hiit.getTotalTime()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveFlutter.of(context).fontSize(10),
                                  fontFamily: "Open Sans")),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context) => WorkoutScreen(
                                        hiit: _hiit
                                    )));},
                              backgroundColor: Colors.black45,
                              splashColor: Colors.deepPurple[800],
                              icon: Icon(
                                  Icons.play_arrow,
                                  size: ResponsiveFlutter.of(context).wp(6)),
                              label: Text(
                                  "Start Workout",
                                  style: TextStyle(
                                      fontFamily: "Open Sans",
                                      fontSize: ResponsiveFlutter.of(context).fontSize(2))
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 40, 40, 40),
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          // Exercise Time
                          ListTile(
                            title: Text(
                                "Exercise Time",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                              formatTime(_hiit.workTime),
                              style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.9))),
                            leading: Icon(
                                Icons.timer,
                                size: ResponsiveFlutter.of(context).wp(7)),
                            onTap: () {
                              showDialog<Duration>(
                                context: context,
                                builder: (BuildContext context) {
                                  return DurationPicker(
                                    // Set the initial duration
                                    initDuration: _hiit.workTime,
                                    title: Text("Exercise time for each rep",
                                      textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Raleway",
                                            fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                            fontWeight: FontWeight.w500))
                                  );
                                }).then((workTime){
                                // If null, don't do anything
                                if (workTime == null) return;
                                // Update the work time to reflect user input
                                _hiit.workTime = workTime;
                                _onHiitChanged();
                              });
                            },
                          ),
                          // Rest Time
                          ListTile(
                            title: Text(
                              "Rest Time",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                formatTime(_hiit.repRest),
                                style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.9))),
                            leading: Icon(
                                Icons.timer,
                                size: ResponsiveFlutter.of(context).wp(7)),
                            onTap: () {
                              showDialog<Duration>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DurationPicker(
                                      // Set the initial duration
                                        initDuration: _hiit.repRest,
                                        title: Text("Rest time between each rep",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Raleway",
                                                fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                                fontWeight: FontWeight.w500))
                                    );
                                  }).then((repRestTime){
                                // If null, don't do anything
                                if (repRestTime == null) return;
                                // Update the rest time between each rep to reflect user input
                                _hiit.repRest = repRestTime;
                                _onHiitChanged();
                              });
                            },
                          ),
                          // Reps
                          ListTile(
                            title: Text(
                                "Reps",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                '${_hiit.reps}',
                                style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.9))),
                            leading: Icon(
                                Icons.repeat,
                                size: ResponsiveFlutter.of(context).wp(7)),
                            onTap: () {
                              showDialog<int>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return NumberPickerDialog.integer(
                                        minValue: 1,
                                        maxValue: 10,
                                        // Set the initial value
                                        initialIntegerValue: _hiit.reps,
                                        title: Text("Reps in each set",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Raleway",
                                                fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                                fontWeight: FontWeight.w500))
                                    );
                                  }).then((reps){
                                // If null, don't do anything
                                if (reps == null) return;
                                // Update the number of reps to reflect user input
                                _hiit.reps = reps;
                                _onHiitChanged();
                              });
                            },
                          ),
                          // Sets
                          ListTile(
                            title: Text(
                                "Sets",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                '${_hiit.sets}',
                                style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.9))),
                            leading: Icon(
                                Icons.fitness_center,
                                size: ResponsiveFlutter.of(context).wp(7)),
                            onTap: () {
                              showDialog<int>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return NumberPickerDialog.integer(
                                        minValue: 1,
                                        maxValue: 10,
                                        // Set the initial value
                                        initialIntegerValue: _hiit.sets,
                                        title: Text("Sets in the workout",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Raleway",
                                                fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                                fontWeight: FontWeight.w500))
                                    );
                                  }).then((sets){
                                // If null, don't do anything
                                if (sets == null) return;
                                // If there is only 1 set in the workout, set the set rest time to 0
                                if (sets == 1) { _hiit.setRest = Duration(seconds: 0);}
                                // Update the number of sets to reflect user input
                                _hiit.sets = sets;
                                _onHiitChanged();
                              });
                            },
                          ),
                          // Set Rest
                          ListTile(
                            title: Text(
                                "Set Rest",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                formatTime(_hiit.setRest),
                                style: TextStyle(fontSize: ResponsiveFlutter.of(context).fontSize(1.9))),
                            leading: Icon(
                                Icons.timer,
                                size: ResponsiveFlutter.of(context).wp(7)),
                            onTap: () {
                              showDialog<Duration>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DurationPicker(
                                      // Set the initial duration
                                        initDuration: _hiit.setRest,
                                        title: Text("Rest time between each set",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Raleway",
                                                fontSize: ResponsiveFlutter.of(context).fontSize(2.3),
                                                fontWeight: FontWeight.w500))
                                    );
                                  }).then((setRestTime){
                                // If null, don't do anything
                                if (setRestTime == null) return;
                                // Update the rest time after each set to reflect user input
                                _hiit.setRest = setRestTime;
                                _onHiitChanged();
                              });
                            },
                          ),
                        ]),
                      ),
                    ), width: double.infinity,
                  ),
                ),
              ],
            ), // Main page contents
          ),
        ],
      ),
    );
  }
}
