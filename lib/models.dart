import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:sound_mode/sound_mode.dart';
import 'main.dart';
import 'dart:io' show Platform;

AudioCache player = AudioCache();

// Default values for the timer
Hiit get defaultHiit => Hiit(
  reps: 3,
  workTime: Duration(seconds: 60),
  repRest: Duration(seconds: 30),
  sets: 2,
  setRest: Duration(seconds: 45),
  delayTime: Duration(seconds: 3)
);

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
  Duration delayTime;

  Hiit({
    this.reps,
    this.workTime,
    this.repRest,
    this.sets,
    this.setRest,
    this.delayTime,
  });

  Duration getTotalTime() {
    return (workTime * reps * sets) + (repRest * sets * (reps-1)) + (setRest * (sets-1));
  }

  Hiit.fromJson(Map<String, dynamic> json) :
    reps = json['reps'],
    workTime = Duration(seconds: json['workTime']),
    repRest = Duration(seconds: json['repRest']),
    sets = json['sets'],
    setRest = Duration(seconds: json['setRest']),
    delayTime = Duration(seconds: json['delayTime']);

  Map<String, dynamic> toJson() => {
    'reps': reps,
    'workTime': workTime.inSeconds,
    'repRest': repRest.inSeconds,
    'sets': sets,
    'setRest': setRest.inSeconds,
    'delayTime': delayTime.inSeconds,
  };
}

// All the possible workout states
enum WorkoutState {
  initial,
  starting,
  exercising,
  repResting,
  setResting,
  finished
}

class Workout {
  Hiit _hiit;
  Timer _timer;

  // Sounds which will be used during the workout
  String countdownSound = "chime.mp3";
  String restSound = "alert_notification.mp3";
  String endSound = "positive_tone_1.mp3";
  String startSound = "positive_tone_2.mp3";

  // Callback for when the workout state is changed
  Function _onStateChanged;
  WorkoutState _step = WorkoutState.initial;

  // Time left in the current stage
  Duration _timeRemaining;
  // Total time elapsed
  Duration _totalTimeElapsed = Duration(seconds: 0);

  // Current rep
  int _rep = 0;
  // Current set
  int _set = 0;

  Workout(this._hiit, this._onStateChanged);

  // Getters
  get hiit => _hiit;
  get rep => _rep;
  get set => _set;
  get step => _step;
  get timeRemaining => _timeRemaining;
  get totalTimeElapsed => _totalTimeElapsed;
  get isActive => _timer != null && _timer.isActive;

  get timeRemainingSeconds => _timeRemaining.inSeconds;
  get timeElapsedSeconds => _totalTimeElapsed.inSeconds;
  get workTime => _hiit.workTime.inSeconds;
  get repRestTime => _hiit.repRest.inSeconds;
  get totalReps => _hiit.reps;
  get totalSets => _hiit.sets;
  get setRestTime => _hiit.setRest.inSeconds;

  percentage(){
    if (_timer.isActive || !_timer.isActive) {
      if (_step == WorkoutState.starting) {
        return 1-(timeRemainingSeconds/3);
      } else if(_step == WorkoutState.exercising) {
        return 1-(timeRemainingSeconds/workTime);
      } else if (_step == WorkoutState.repResting) {
        return 1-(timeRemainingSeconds/repRestTime);
      } else if (_step == WorkoutState.setResting) {
        return 1-(timeRemainingSeconds/setRestTime);
      } else return 1.0;
    }
  }

  _tick(Timer timer) {
    if (_step != WorkoutState.starting) {
      _totalTimeElapsed += Duration(seconds: 1);
    }
    if (_timeRemaining.inSeconds == 1) {_nextStep();}
    else {
      _timeRemaining -= Duration(seconds: 1);
      // Play a countdown before the workout starts
      //if (_timeRemaining.inSeconds <= 3 && _step == WorkoutState.starting) {

      // Play a countdown the last 3 seconds of the current stage
      if (_timeRemaining.inSeconds <= 3) {_playSound(countdownSound);}
    }
    _onStateChanged();
  }

  // Starts or resumes the workout
  start() {
    // Need to consider the current workout state
    if (_step == WorkoutState.initial) {
      _playSound(countdownSound);
      _step = WorkoutState.starting;

      if (_hiit.delayTime.inSeconds == 0) {_nextStep();}
      else {_timeRemaining = _hiit.delayTime;}
    }
    _timer = Timer.periodic(Duration(seconds: 1), _tick);
    _onStateChanged();
  }

  // Pauses the workout
  pause() {
    _timer.cancel();
    _onStateChanged();
  }

  // Stops the timer and sets the workout state to finished
  // and time remaining to 0
  stop() {
    _timer.cancel();
    _step = WorkoutState.finished;
    _timeRemaining = Duration(seconds: 0);
  }

  // Stops the timer without changing the current state
  dispose() { _timer.cancel(); }

  // Moves the workout to the next step
  _nextStep() {
    // Need to consider the current state of the workout
    if (_step == WorkoutState.exercising) {
      if (rep == _hiit.reps) {
        if (set == _hiit.sets) { _finish(); }
        else {_startSetRest(); }
      }
      else { _startRepRest(); }
    }
    else if (_step == WorkoutState.repResting) { _startRep(); }
    else if (_step == WorkoutState.starting
        ||_step == WorkoutState.setResting) {
      _startSet();
    }
  }

  // Starts the current rep by increasing the rep counter, setting the current
  // workout state to exercising, and time remaining to the current work time
  _startRep() {
    _rep++;
    _step = WorkoutState.exercising;
    _timeRemaining = _hiit.workTime;
    _playSound(startSound);
  }

  // Starts the timer for the rep rest by setting the current workout state to
  // rep resting and once the time left in rep rest reaches 0, moves on to the
  // next step of the workout
  _startRepRest() {
    _step = WorkoutState.repResting;
    // If the time remaining in the rep rest is 0, move on to the next step
    if (_hiit.repRest.inSeconds == 0) {
      _nextStep();
      return;
    }
    _playSound(restSound);
    _timeRemaining = _hiit.repRest;
  }

  // Starts the current set by increasing the set counter, setting the rep to
  // 1 since it's the first rep in the set, setting the current workout state
  // to exercising, and time remaining to the current work time
  _startSet() {
    _set++;
    _rep = 1;
    _step = WorkoutState.exercising;
    _timeRemaining = _hiit.workTime;
    _playSound(startSound);
  }

  _startSetRest() {
    _step = WorkoutState.setResting;
    // If the time remaining in the rep rest is 0, move on to the next step
    if (_hiit.setRest.inSeconds == 0) {
      _nextStep();
      return;
    }
    _playSound(restSound);
    _timeRemaining = _hiit.setRest;
  }

  _finish() {
    // Cancel the timer
    _timer.cancel();
    _showNotification();
    _step = WorkoutState.finished;
    _timeRemaining = Duration(seconds: 0);
    if (Platform.isAndroid) {
      _playSound(endSound);
    }
  }

  // Function to play a sound
  Future _playSound(String sound) async {
    String ringerStatus = await SoundMode.ringerModeStatus;
    if (Platform.isIOS) {
      // iOS doesn't push the message to flutter, so need to read twice
      await Future.delayed(Duration(milliseconds: 10), () async {
        ringerStatus = await SoundMode.ringerModeStatus;
      });
    }

    // Print to console for debugging
    //debugPrint(ringerStatus);

    // If ringer is on, play a sound
    if (ringerStatus.contains("Normal Mode")) {return await player.play(sound);}
    // If vibrate mode, send a vibration
    else if (ringerStatus.contains("Vibrate Mode")) {return HapticFeedback.vibrate();}
    return;
  }

  void _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.max,
        priority: Priority.high,
    );

    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails = new NotificationDetails(
        android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0, "HiitMe Interval Timer", "Workout Complete!", generalNotificationDetails
    );
  }
}