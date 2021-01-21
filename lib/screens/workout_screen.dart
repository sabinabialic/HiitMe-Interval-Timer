import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models.dart';

// All the possible states of the timer
String workoutStage (WorkoutState stage) {
  switch (stage) {
    case WorkoutState.starting: return "Starting";
    case WorkoutState.exercising: return "Exercise";
    case WorkoutState.repResting: return "Rep Rest";
    case WorkoutState.setResting: return "Set Rest";
    case WorkoutState.finished: return "Finished";
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
    // Start the timer
    _start();
  }

  //
  _onWorkoutChanged() {
    this.setState(() {});
  }

  // Dispose of the state of the workout
  @override
  disposeState() {
    // TODO: implement disposeState
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
            // TODO - Implement states before being able to do this
            //decoration: _backgroundColour(theme),
            color: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                Expanded(child: Row()),
                // This row contains the name of the stage of the workout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Step",
                      //workoutStage(_workout.step),
                      style: TextStyle( fontSize: 60.0, color: Colors.white)
                    )
                  ],
                ),
                // Divider
                Divider (height: 30, color: Colors.white),

                // Time remaining
                Container (
                  padding: EdgeInsets.only(bottom: 150),
                  width: double.infinity,
                  child: FittedBox(
                    child: Text(
                        "TimeLeft",
                        style: TextStyle(color: Colors.white)
                    )
                  )),
                // Divider
                Divider (height: 30, color: Colors.white),

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
                          child: Text("Set",
                          style: TextStyle(
                            fontSize: 26.0, color: Colors.white),
                          textAlign: TextAlign.center)
                        ),
                        // Rep
                        TableCell(
                            child: Text("Rep",
                                style: TextStyle(
                                    fontSize: 26.0, color: Colors.white),
                                textAlign: TextAlign.center)
                        ),
                        // Total Time
                        TableCell(
                            child: Text("Total Time",
                                style: TextStyle(
                                    fontSize: 26.0, color: Colors.white),
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
