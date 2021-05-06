import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:interval_timer/screens/workout_screen.dart';
import 'package:interval_timer/widgets/customalertdialog.dart';
import 'package:interval_timer/widgets/durationpicker.dart';
import 'package:interval_timer/widgets/integerpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../main.dart';
import '../models.dart';

class HiitScreen extends StatefulWidget {
  SharedPreferences prefs;

  HiitScreen({@required this.prefs});

  @override
  State<StatefulWidget> createState() => _HiitScreenState();
}

class _HiitScreenState extends State<HiitScreen> {
  Hiit _hiit;

  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 3, minLaunches: 7,
    remindDays: 2, remindLaunches: 5,
    googlePlayIdentifier: 'com.greydanedevelopment.hiitme_interval_timer',
    appStoreIdentifier: '1564361054',
  );

  @override
  initState() {
    // Initialize shared preferences
    var json = widget.prefs.getString('hiit');
    _hiit = json != null? Hiit.fromJson(jsonDecode(json)) : defaultHiit;

    // App rating prompt
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _rateMyApp.init();
      if (mounted && _rateMyApp.shouldOpenDialog) {
        _rateMyApp.showRateDialog(context);
      }
    });

    super.initState();
  }

  // Callback for when the duration changes
  _onHiitChanged() {
    setState(() {});
    _saveHiit();
  }

  // Saving to shared preferences
  _saveHiit() { widget.prefs.setString('hiit', json.encode(_hiit.toJson())); }

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
        drawer: hiitAppDrawer(),
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
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.045),
                              child: FocusedMenuHolder(
                                child: RaisedButton.icon(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(75.0),
                                  ),
                                  padding: EdgeInsets.fromLTRB(40, 8, 40, 8),
                                  elevation: 15.0, color: Colors.black38,
                                  icon: Icon(Icons.play_arrow, color: Colors.white,
                                    size: MediaQuery.of(context).size.width * 0.09),
                                  label: Text("Start Timer", style: TextStyle(
                                    fontFamily: "Open Sans", color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.width * 0.055)
                                  ),
                                  onPressed: () { Navigator.push( context,
                                      MaterialPageRoute(builder: (context) => WorkoutScreen(hiit: _hiit)));
                                  },
                                ),

                                // On long hold, opens a focused menu
                                menuItems: <FocusedMenuItem> [
                                  FocusedMenuItem(
                                      title: Text("Start Timer",
                                          style: TextStyle(fontFamily: "Roboto", fontSize: 16)),
                                      trailingIcon: Icon(Icons.play_arrow),
                                      onPressed: (){
                                        Navigator.push( context,
                                            MaterialPageRoute(builder: (context) => WorkoutScreen(hiit: _hiit)));
                                      }),
                                  FocusedMenuItem(
                                      title: Text("Save Timer",
                                          style: TextStyle(fontFamily: "Roboto", fontSize: 16)),
                                      trailingIcon: Icon(Icons.save_alt),
                                      onPressed: (){
                                        debugPrint("Save Timer Pressed");
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return InputAlertDialog(
                                                // Set the initial duration
                                                title: Text("Save Timer", textAlign: TextAlign.center, style: PickerTextStyle())
                                              );
                                            }
                                        );
                                      }),
                                ],
                                menuWidth: MediaQuery.of(context).size.width * 0.6,
                                menuOffset: 20,
                              )),
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
                              title: Text("Work Time", style: PickerTextStyle()),
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
                                        title: Text("Work Time", textAlign: TextAlign.center, style: PickerTextStyle())
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
                              title: Text("Rest Time", style: PickerTextStyle()),
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
                                            title: Text("Rest Time", textAlign: TextAlign.center, style: PickerTextStyle())
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
                              title: Text("Rounds", style: PickerTextStyle()),
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
                                        child: IntegerPicker(
                                            initialIntegerValue: _hiit.reps,
                                            title: Text("Rounds", textAlign: TextAlign.center, style: PickerTextStyle())
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
                              title: Text("Total Workouts", style: PickerTextStyle()),
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
                                        child: IntegerPicker(
                                            // Set the initial value
                                            initialIntegerValue: _hiit.sets,
                                            title: Text("Total Workouts", textAlign: TextAlign.center, style: PickerTextStyle()),
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
                              title: Text("Rest Between Workouts", style: PickerTextStyle()),
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
                                          title: Text("Rest Between Workouts", textAlign: TextAlign.center, style: PickerTextStyle())
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

  TextStyle PickerTextStyle() {
    return TextStyle(
        fontFamily: "Roboto", fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.width * 0.05);
  }

  // App Drawer
  hiitAppDrawer() {
    return Drawer(
    // ListView ensures the user can scroll through the options if there
    // is not enough space on the screen
      child: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          SizedBox(height: 100),
          ListTile(
            //leading: Icon(Icons.save),
            title: Text('Timer Presets', style: TextStyle(
                fontFamily: "Roboto", color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.05))),
          ListTile(
            title: Text('Default Timer', style: TextStyle(
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
          ListTile(
            title: Text('EMOM', style: TextStyle(
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
          ListTile(
            title: Text('My Presets', style: TextStyle(
                fontFamily: "Roboto", color: Colors.black54, fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.04)),
              // Close the drawer
              onTap: () {Navigator.pop(context);}),
          ]));
  }
}
