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
  @override
  State<StatefulWidget> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>{
  Workout _workout;

  // Initialize the state of the workout
  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  // Dispose of the state of the workout
  @override
  disposeState() {
    // TODO: implement disposeState
    super.dispose();
  }

  // Start the workout
  _start() {
    _workout.pause();
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
    // TODO: implement build
    throw UnimplementedError();
  }
}