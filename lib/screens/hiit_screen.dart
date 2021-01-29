import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interval_timer/screens/workout_screen.dart';
import 'package:interval_timer/widgets/durationpicker.dart';

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
  _onHiitChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Interval Timer",
          style: TextStyle(fontFamily: "Roboto", fontSize: 28)
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
                  padding: EdgeInsets.fromLTRB(20, 150, 20, 50),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_hiit.formatTime(_hiit.getTotalTime()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: FloatingActionButton.extended(
                              // TODO: Start the workout
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutScreen(
                                      hiit: _hiit
                                    ))
                                );
                              },
                              backgroundColor: Colors.black45,
                              splashColor: Colors.deepPurple[800],
                              icon: Icon(Icons.play_arrow),
                              label: Text(
                                  "Start Workout",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16
                                  )
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
                      padding: EdgeInsets.fromLTRB(40, 50, 40, 50),
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          // Exercise Time
                          ListTile(
                            title: Text(
                                "Exercise Time",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            subtitle: Text(_hiit.formatTime(_hiit.workTime)),
                            leading: Icon(Icons.timer),
                            onTap: () {
                              // TODO: Show duration picker
                              showDialog<Duration>(
                                context: context,
                                builder: (BuildContext context) {
                                  return DurationPicker(
                                    initDuration: _hiit.workTime,
                                    title: Text("Exercise time for each rep",
                                      textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16)
                                    )
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
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            subtitle: Text(_hiit.formatTime(_hiit.repRest)),
                            leading: Icon(Icons.timer),
                            onTap: () {
                              // TODO: Show duration picker
                              showDialog<Duration>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DurationPicker(
                                        initDuration: _hiit.repRest,
                                        title: Text("Rest time between each rep",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16)
                                        )
                                    );
                                  }).then((repRestTime){
                                // If null, don't do anything
                                if (repRestTime == null) return;
                                // Update the work time to reflect user input
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
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            subtitle: Text('${_hiit.reps}'),
                            leading: Icon(Icons.repeat),
                            onTap: () {
                              // TODO: Show duration picker
                            },
                          ),
                          // Sets
                          ListTile(
                            title: Text(
                                "Sets",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.w500,
                                )
                            ),
                            subtitle: Text('${_hiit.sets}'),
                            leading: Icon(Icons.fitness_center),
                            onTap: () {
                              // TODO: Show duration picker
                            },
                          ),
                          // Set Rest
                          ListTile(
                            title: Text(
                                "Set Rest",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            subtitle: Text(_hiit.formatTime(_hiit.setRest)),
                            leading: Icon(Icons.timer),
                            onTap: () {
                              // TODO: Show duration picker
                              showDialog<Duration>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DurationPicker(
                                        initDuration: _hiit.setRest,
                                        title: Text("Rest time between each set",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16)
                                        )
                                    );
                                  }).then((setRestTime){
                                // If null, don't do anything
                                if (setRestTime == null) return;
                                // Update the work time to reflect user input
                                _hiit.repRest = setRestTime;
                                _onHiitChanged();
                              });
                            },
                          ),
                        ]),
                      ),
                    ),
                    width: double.infinity,
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
