import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models.dart';

// All the possible states of the timer
String workoutStage (WorkoutState step) {
  switch (step) {
    case WorkoutState.starting: return "STARTING";
    case WorkoutState.exercising: return "EXERCISE";
    case WorkoutState.repResting: return "REP REST";
    case WorkoutState.setResting: return "SET REST";
    case WorkoutState.finished: return "FINISHED";
    default: return "";
  }
}

class WorkoutScreen extends StatefulWidget{
  final Hiit hiit;
  WorkoutScreen({this.hiit});

  @override
  State<StatefulWidget> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>{
  Workout _workout;

  // Initialize the state of the workout
  @override
  initState() {
    super.initState();
    _workout = Workout(widget.hiit, _onWorkoutChanged);
    _start();
  }

  // Callback for when the workout state changes
  _onWorkoutChanged() {
    this.setState(() {});
  }

  // Dispose of the state of the workout
  @override
  disposeState() {
    _workout.dispose();
    super.dispose();
  }

  // Start the workout
  _start() {
    _workout.start();
  }

  // Pause the workout
  _pause() {
    _workout.pause();
  }

  // Change the background of the screen depending on the workout state
  _backgroundColour(ThemeData theme) {
    switch(_workout.step) {
      case WorkoutState.exercising: return Colors.lightGreen;
      case WorkoutState.repResting: return Colors.blueAccent;
      case WorkoutState.setResting: return Colors.pink;
      default: return BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Colors.purple, Colors.indigo],
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight
        )
      );
    }
  }

  // Workout screen user interface
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget> [
          Container(
            // Background of the screen
            decoration: _backgroundColour(theme),
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                Expanded(child: Row()),
                // This row contains the name of the stage of the workout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        workoutStage(_workout.step),
                        style: TextStyle(
                          fontSize: 58.0,
                          fontFamily: "Raleway",
                          color: Colors.white70
                        )
                    )
                  ],
                ),
                // Divider
                Divider (height: 50, color: Colors.white),

                // Time remaining
                Container (
                  padding: EdgeInsets.only(bottom: 18),
                  width: double.infinity,
                  child: FittedBox(
                    child: Text(
                        formatTime(_workout.timeRemaining),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 60.0,
                            fontFamily: "Open Sans"
                        )
                    )
                  )),
                // Divider
                Divider (height: 50, color: Colors.white),

                // This table shows more info about the workout
                Table(
                  // Setting up the columns
                  columnWidths: {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(0.5),
                    2: FlexColumnWidth(1.0)
                  },
                  // Setting up the rows
                  children: [
                    // First row - Contains the text
                    TableRow(
                      children: [
                        // Set
                        TableCell(
                          child: Text("SET",
                          style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 24.0,
                              color: Colors.white70),
                          textAlign: TextAlign.center)
                        ),
                        // Rep
                        TableCell(
                            child: Text("REP",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: 24.0,
                                    color: Colors.white70),
                                textAlign: TextAlign.center)
                        ),
                        // Total Time
                        TableCell(
                            child: Text("TIME ELAPSED",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: 22.0,
                                    color: Colors.white70),
                                textAlign: TextAlign.center)
                        ),
                      ]),

                    // Second row - Contains the info
                    TableRow(
                        children: [
                          // Set
                          TableCell(
                              child: Text("1",
                                  style: TextStyle(
                                      fontSize: 26.0, color: Colors.white),
                                  textAlign: TextAlign.center)
                          ),
                          // Rep
                          TableCell(
                              child: Text("2",
                                  style: TextStyle(
                                      fontSize: 26.0, color: Colors.white),
                                  textAlign: TextAlign.center)
                          ),
                          // Total Time
                          TableCell(
                              child: Text("1:45",
                                  style: TextStyle(
                                      fontSize: 26.0, color: Colors.white),
                                  textAlign: TextAlign.center)
                          ),
                        ]),
                  ],
                ),
                // TODO - Implement
                //Expanded (child: _buttonBar())
                Divider(height: 200)
              ],
            )
          )
        ],
      )
    );
  }

  // Start/Pause button bar
  Widget _buttonBar() {
    // TODO - Create a button bar
    throw UnimplementedError();
  }
}
