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

  // Function to format the time
  String formatTime(Duration duration) {
    String minutes = (duration.inMinutes).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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