import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
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
  _onWorkoutChanged() { this.setState(() {}); }

  // Dispose of the state of the workout
  @override
  disposeState() {
    _workout.dispose();
    super.dispose();
  }

  // Start the workout
  _start() { _workout.start(); }

  // Pause the workout
  _pause() { _workout.pause(); }

  // Change the background of the screen depending on the workout state
  _backgroundColour(ThemeData theme) {
    switch(_workout.step) {
      case WorkoutState.exercising: return Colors.lightGreen;
      case WorkoutState.repResting: return Colors.blueAccent;
      case WorkoutState.setResting: return Colors.pink;
      default: return theme.backgroundColor;
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
            decoration: _getDecoration(theme),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                // This row contains the name of the stage of the workout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      workoutStage(_workout.step),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        fontFamily: "Raleway",
                        color: Colors.white70
                      )
                    )
                  ],
                ),
                // Divider
                Divider (height: MediaQuery.of(context).size.height * 0.05, color: Colors.white),

                // Time remaining
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: CircularPercentIndicator(
                    percent: _workout.percentage(),
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animateFromLastPercent: true,
                    radius: MediaQuery.of(context).size.height * 0.4,
                    lineWidth: MediaQuery.of(context).size.height * 0.02,
                    progressColor: _workout.isActive ? Colors.white : Colors.white70,
                    backgroundColor: Colors.black12,
                    center: Text(formatTime(_workout.timeRemaining),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.15,
                          fontFamily: "Open Sans"
                    )),
                  )
                ),

                // Divider
                Divider (height: MediaQuery.of(context).size.height * 0.05, color: Colors.white),

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
                              fontSize: MediaQuery.of(context).size.width * 0.05,
                              color: Colors.white70),
                          textAlign: TextAlign.center)
                        ),
                        // Rep
                        TableCell(
                            child: Text("REP",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    color: Colors.white70),
                                textAlign: TextAlign.center)
                        ),
                        // Total Time
                        TableCell(
                            child: Text("TIME ELAPSED",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    color: Colors.white70),
                                textAlign: TextAlign.center)
                        ),
                      ]),

                    // Second row - Contains the info
                    TableRow(
                        children: [
                          // Set
                          TableCell(
                              child: Text('${_workout.set}',
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1, color: Colors.white),
                                  textAlign: TextAlign.center)
                          ),
                          // Rep
                          TableCell(
                              child: Text('${_workout.rep}',
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1, color: Colors.white),
                                  textAlign: TextAlign.center)
                          ),
                          // Total Time
                          TableCell(
                              child: Text(formatTime(_workout.totalTimeElapsed),
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1, color: Colors.white),
                                  textAlign: TextAlign.center)
                          ),
                        ]),
                  ],
                ),
                Expanded(child: _buttonBar())
              ],
            )
          )
        ],
      )
    );
  }
  
  // Sets the background color(s) of the screen
  _getDecoration(ThemeData theme) {
    // When the workout step is initial, starting, or finished fill the background
    // with a gradient
    if (_workout.step == WorkoutState.initial ||
        _workout.step == WorkoutState.starting ||
        _workout.step == WorkoutState.finished) {
      return BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.purple, Colors.indigo],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight
          )
      );
      // Otherwise, the colour of the background should be a solid colour
    } else { return BoxDecoration(color: _backgroundColour(theme)); }
  }

  // Start/Pause button bar
  Widget _buttonBar() {
    // On finished, show a button to go back to main screen
    if (_workout.step == WorkoutState.finished) {
      return IconButton(
        padding: EdgeInsets.all(10),
        iconSize: MediaQuery.of(context).size.height * 0.12,
        // When pressed, pop the current screen
        onPressed: () => Navigator.pop(context),
        // Icon on the button
        icon: Icon(Icons.home, color: Colors.white70)
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            iconSize: MediaQuery.of(context).size.height * 0.12,
            // When pressed, dispose the workout and pop the current screen
            onPressed: () => {
              _workout.dispose(),
              Navigator.pop(context),
            },
            // Icon on the button
            icon: Icon(Icons.cancel, color: Colors.white70)
          ),
          IconButton(
            iconSize: MediaQuery.of(context).size.height * 0.12,
            onPressed: _workout.isActive? _pause : _start,
            // Icon on the button depends on if the workout is active or not
            icon: Icon(_workout.isActive ?
              // If active pause icon, if inactive play icon
              Icons.pause_circle_filled : Icons.play_circle_filled,
              color: Colors.white70
            )
          )
        ],
      );
    }
  }
}
