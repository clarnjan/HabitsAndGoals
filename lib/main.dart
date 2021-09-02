import 'package:diplomska1/Widgets/Home.dart';
import 'package:diplomska1/Widgets/NewTask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/task/new': (context) => NewTask(),
          '/task/details': (context) => NewTask()
        });
  }
}
