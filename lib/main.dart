import 'package:diplomska1/Widgets/Week%20widgets/WeekDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Widgets/Goal widgets/Goals.dart';
import 'Widgets/Habit widgets/Habits.dart';
import 'Widgets/Task widgets/Tasks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[800], //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          unselectedWidgetColor: Colors.white, // <-- your color
        ),
        initialRoute: '/week',
        routes: {
          '/week': (context) => WeekDetails(),
          '/habits': (context) => Habits(),
          '/tasks': (context) => Tasks(),
          '/goals': (context) => Goals(),
        });
  }
}
