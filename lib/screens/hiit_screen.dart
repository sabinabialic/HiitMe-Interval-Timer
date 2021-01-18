import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interval_timer/screens/workout_screen.dart';

class HiitScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HiitScreenState();
}

class _HiitScreenState extends State<HiitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Interval Timer"),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
        backgroundColor: Color(0xFFFFFF),
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
                  padding: EdgeInsets.fromLTRB(20, 150, 20, 50),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("10:10",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: FloatingActionButton.extended(
                              // TODO: Start the workout
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutScreen())
                                );
                              },
                              backgroundColor: Colors.black45,
                              splashColor: Colors.deepPurple[800],
                              icon: Icon(Icons.play_arrow),
                              label: Text("Start Workout"),
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
                      padding: EdgeInsets.fromLTRB(40, 50, 40, 50),
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          // Exercise Time
                          ListTile(
                            title: Text('Exercise Time'),
                            subtitle: Text('exercise time'),
                            leading: Icon(Icons.timer),
                            onTap: () {
                              // TODO: Show duration picker
                            },
                          ),
                          // Rest Time
                          ListTile(
                            title: Text('Rest Time'),
                            subtitle: Text('rest time'),
                            leading: Icon(Icons.timer),
                            onTap: () {
                              // TODO: Show duration picker
                            },
                          ),
                          // Reps
                          ListTile(
                            title: Text('Reps'),
                            subtitle: Text('rep time'),
                            leading: Icon(Icons.repeat),
                            onTap: () {
                              // TODO: Show duration picker
                            },
                          ),
                          // Sets
                          ListTile(
                            title: Text('Sets'),
                            subtitle: Text('sets'),
                            leading: Icon(Icons.fitness_center),
                            onTap: () {
                              // TODO: Show duration picker
                            },
                          ),
                          // Set Rest
                          ListTile(
                            title: Text('Set Rest'),
                            subtitle: Text('set rest'),
                            leading: Icon(Icons.timer),
                            onTap: () {
                              // TODO: Show duration picker
                            },
                          ),
                        ]),
                      ),
                    ),
                    width: double.infinity,
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
