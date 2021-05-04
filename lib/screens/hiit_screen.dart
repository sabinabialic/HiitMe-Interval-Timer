import 'package:flutter/material.dart';
import 'package:interval_timer/screens/workout_screen.dart';
import 'package:interval_timer/widgets/durationpicker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../main.dart';
import '../models.dart';

class HiitScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HiitScreenState();
}

class _HiitScreenState extends State<HiitScreen> {
  Hiit _hiit;

  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3, minLaunches: 7,
    remindDays: 3, remindLaunches: 5,
    googlePlayIdentifier: 'com.greydanedevelopment.hiitme_interval_timer',
    appStoreIdentifier: '1564361054',
  );

  @override
  initState() {
    _hiit = defaultHiit;
    super.initState();

    // App rating prompt
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _rateMyApp.init();
      if (mounted && _rateMyApp.shouldOpenDialog) {
        _rateMyApp.showRateDialog(context);
      }
    });
  }

  // Callback for when the duration changes
  _onHiitChanged() { setState(() {}); }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Interval Timer",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Roboto",
                fontSize: MediaQuery.of(context).size.width * 0.07)),
          elevation: 0.0, backgroundColor: Colors.transparent,
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
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.15, 0, MediaQuery.of(context).size.height * 0.08),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(formatTime(_hiit.getTotalTime()),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.width * 0.25,
                                    fontFamily: "Open Sans")),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                              child: RaisedButton.icon(
                                onPressed: () { Navigator.push( context,
                                    MaterialPageRoute(builder: (context) => WorkoutScreen(hiit: _hiit)));},
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(75.0),
                                ),
                                padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                                elevation: 15.0, color: Colors.black38,
                                icon: Icon(Icons.play_arrow, color: Colors.white,
                                    size: MediaQuery.of(context).size.width * 0.09),
                                label: Text("Start Workout", style: TextStyle(
                                    fontFamily: "Open Sans", color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.width * 0.055)
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
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                        child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                            // Exercise Time
                            ListTile(
                              title: Text(
                                  "Work Time",
                                  style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                formatTime(_hiit.workTime),
                                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045)),
                              leading: Icon(
                                  Icons.timer,
                                  size: MediaQuery.of(context).size.width * 0.09),
                              onTap: () {
                                showDialog<Duration>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                      child: DurationPicker(
                                        // Set the initial duration
                                        initDuration: _hiit.workTime,
                                        title: Text("Work Time", textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Roboto",
                                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                                fontWeight: FontWeight.w500))
                                      ),
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
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  formatTime(_hiit.repRest),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045)),
                              leading: Icon(
                                  Icons.timer,
                                  size: MediaQuery.of(context).size.width * 0.09),
                              onTap: () {
                                showDialog<Duration>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                        child: DurationPicker(
                                          // Set the initial duration
                                            initDuration: _hiit.repRest,
                                            title: Text("Rest Time",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                                    fontWeight: FontWeight.w500))
                                        ),
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
                                  "Rounds",
                                  style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  '${_hiit.reps}',
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045)),
                              leading: Icon(
                                  Icons.repeat,
                                  size: MediaQuery.of(context).size.width * 0.09),
                              onTap: () {
                                showDialog<int>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                        child: NumberPickerDialog.integer(
                                            minValue: 1, maxValue: 20,
                                            // Set the initial value
                                            initialIntegerValue: _hiit.reps,
                                            title: Text("Rounds",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                                    fontWeight: FontWeight.w500))
                                        ),
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
                                  "Total Workouts",
                                  style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  '${_hiit.sets}',
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045)),
                              leading: Icon(
                                  Icons.fitness_center,
                                  size: MediaQuery.of(context).size.width * 0.09),
                              onTap: () {
                                showDialog<int>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                        child: NumberPickerDialog.integer(
                                            minValue: 1, maxValue: 20,
                                            // Set the initial value
                                            initialIntegerValue: _hiit.sets,
                                            title: Text("Total Workouts",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Roboto",
                                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                                    fontWeight: FontWeight.w500)),
                                        ),
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
                                  "Rest Between Workouts",
                                  style: TextStyle(
                                      fontFamily: "Raleway",
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  formatTime(_hiit.setRest),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045)),
                              leading: Icon(
                                  Icons.timer,
                                  size: MediaQuery.of(context).size.width * 0.09),
                              onTap: () {
                                showDialog<Duration>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                        child: DurationPicker(
                                          // Set the initial duration
                                          initDuration: _hiit.setRest,
                                          title: Text("Rest Between Workouts",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: MediaQuery.of(context).size.width * 0.05,
                                                  fontWeight: FontWeight.w500))
                                        ),
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
      ),
    );
  }
}
