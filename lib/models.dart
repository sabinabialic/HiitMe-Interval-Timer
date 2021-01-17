import 'package:flutter/material.dart';
import 'main.dart';

class Hiit{
  // Reps in a workout
  int reps;
  // Exercise time in each rep
  Duration workTime;
  // Rest time between each rep
  Duration repRest;
  // Sets in a workout
  int sets;
  // Rest time between each set
  Duration setRest;
  // Initial countdown before the workout
  Duration dealyTime;

  Hiit({
    this.reps,
    this.workTime,
    this.repRest,
    this.sets,
    this.setRest,
    this.dealyTime,
  });

  Duration getTotalTime() {
    // TODO: Function to get the total time of the workout
    throw UnimplementedError();
  }

  String formatTime(Duration duration) {
    // TODO: Function to format the time based on user input
    throw UnimplementedError();
  }
}

// All the possible workout states
enum WorkoutState {
  initial,
  starting,
  exercising,
  resting,
  breaking,
  finished
}

class Workout {
  // Callback for when the workout state is changed
  Function _onStateChanged;
  // Workout stage
  WorkoutState _step = WorkoutState.initial;
  // Time left in the current stage
  Duration _timeRemaining;
  // Total time elapsed
  Duration _totalTimeElapsed = Duration(seconds: 0);
  // Current rep
  int _rep = 0;
  // Current set
  int _set = 0;

  // Getters
  get rep => _rep;
  get set => _set;
  get step => _step;
  get timeRemaining => _timeRemaining;
  get totalTimeElapsed => _totalTimeElapsed;

  start() {
    // TODO: Function which starts or resumes the workout
    // Need to consider the current workout state
    throw UnimplementedError();
  }

  pause() {
    // TODO: Function which pauses the workout
    throw UnimplementedError();
  }

  stop() {
    // TODO: Function which stops the workout
    throw UnimplementedError();
  }

  _nextStep() {
    // TODO: Function which moves the workout to the next step
    // Need to consider the current state of the workout
    throw UnimplementedError();
  }

  _startRep() {
    // TODO: Function which starts a new rep for the workout
    throw UnimplementedError();
  }

  _startRepRest() {
    // TODO: Function which starts a rest state for the current rep of the workout
    throw UnimplementedError();
  }

  _startSet() {
    // TODO: Function which starts a new set for the workout
    throw UnimplementedError();
  }

  _startSetRest() {
    // TODO: Function which starts a rest state for the current set of the workout
    throw UnimplementedError();
  }

  _finish() {
    // TODO: Function which sets the state of the workout to finished
    // Cancel the timer
    // Push a notification
    throw UnimplementedError();
  }
}