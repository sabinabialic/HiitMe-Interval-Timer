import 'package:flutter/material.dart';
import 'package:interval_timer/screens/workout_screen.dart';
import 'package:interval_timer/widgets/durationpicker.dart';
import 'package:numberpicker/numberpicker.dart';
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
      // App bar with text
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Interval Timer",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Roboto",
              fontSize: MediaQuery.of(context).size.width * 0.07)
        ),
        elevation: 0.0, backgroundColor: Colors.transparent,
      ),

      // Sliding drawer
      drawer: Drawer(
        // ListView ensures the user can scroll through the options if there
        // is not enough space on the screen
        child: ListView(
          padding: EdgeInsets.all(15),
          children: <Widget>[
            SizedBox(height: 100),
            Row( children: [
              Icon(Icons.save),
              SizedBox(width: 20),
              Text('Timer Presets', style: TextStyle(
                  fontFamily: "Roboto", color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05))
            ]),
            ListTile(subtitle: Text('Default Timer', style: TextStyle(
                fontFamily: "Roboto", color: Colors.black54,
                fontSize: MediaQuery.of(context).size.width * 0.04)),
              onTap: () {
                // Set default values for the timer
                _hiit = defaultHiit;
                // Callback
                _onHiitChanged();
                // Close the drawer
                Navigator.pop(context);
              }),
            ListTile(subtitle: Text('EMOM', style: TextStyle(
                fontFamily: "Roboto", color: Colors.black54,
                fontSize: MediaQuery.of(context).size.width * 0.04)),
              onTap: () {
                // Set default values for EMOM
                _hiit.workTime = Duration(seconds: 60);
                _hiit.repRest = Duration(seconds: 0);
                _hiit.reps = 5;
                _hiit.sets = 1;
                _hiit.setRest = Duration(seconds: 0);
                // Callback
                _onHiitChanged();
                // Close the drawer
                Navigator.pop(context);
              }),
            ListTile(subtitle: Text('E90s', style: TextStyle(
                fontFamily: "Roboto", color: Colors.black54,
                fontSize: MediaQuery.of(context).size.width * 0.04)),
              onTap: () {
                // Set default values for E90s
                _hiit.workTime = Duration(seconds: 90);
                _hiit.repRest = Duration(seconds: 0);
                _hiit.reps = 5;
                _hiit.sets = 1;
                _hiit.setRest = Duration(seconds: 0);
                // Callback
                _onHiitChanged();
                // Close the drawer
                Navigator.pop(context);
              }),
          ],
        )
      ),

      // Main UI
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
                  padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.15, 0, MediaQuery.of(context).size.height * 0.1),
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
                              padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                              elevation: 15.0,
                              color: Colors.black38,
                              icon: Icon(Icons.play_arrow, color: Colors.white,
                                  size: MediaQuery.of(context).size.width * 0.09),
                              label: Text("Start Workout", style: TextStyle(
                                  fontFamily: "Open Sans", color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.06)
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
                      padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          // Exercise Time
                          ListTile(
                            title: Text(
                                "Exercise Time",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: MediaQuery.of(context).size.height * 0.026,
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                              formatTime(_hiit.workTime),
                              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.022)),
                            leading: Icon(
                                Icons.timer,
                                size: MediaQuery.of(context).size.height * 0.04),
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
                                            fontFamily: "Roboto",
                                            fontSize: MediaQuery.of(context).size.height * 0.025,
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
                                    fontSize: MediaQuery.of(context).size.height * 0.026,
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                formatTime(_hiit.repRest),
                                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.022)),
                            leading: Icon(
                                Icons.timer,
                                size: MediaQuery.of(context).size.height * 0.04),
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
                                                fontFamily: "Roboto",
                                                fontSize: MediaQuery.of(context).size.height * 0.025,
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
                                    fontSize: MediaQuery.of(context).size.height * 0.026,
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                '${_hiit.reps}',
                                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.022)),
                            leading: Icon(
                                Icons.repeat,
                                size: MediaQuery.of(context).size.height * 0.04),
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
                                                fontFamily: "Roboto",
                                                fontSize: MediaQuery.of(context).size.height * 0.025,
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
                                    fontSize: MediaQuery.of(context).size.height * 0.026,
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                '${_hiit.sets}',
                                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.022)),
                            leading: Icon(
                                Icons.fitness_center,
                                size: MediaQuery.of(context).size.height * 0.04),
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
                                                fontFamily: "Roboto",
                                                fontSize: MediaQuery.of(context).size.height * 0.025,
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
                                    fontSize: MediaQuery.of(context).size.height * 0.026,
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                formatTime(_hiit.setRest),
                                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.022)),
                            leading: Icon(
                                Icons.timer,
                                size: MediaQuery.of(context).size.height * 0.04),
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
                                                fontFamily: "Roboto",
                                                fontSize: MediaQuery.of(context).size.height * 0.025,
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
