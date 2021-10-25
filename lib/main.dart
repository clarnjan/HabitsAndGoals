import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Widgets/Week%20widgets/WeekDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Widgets/CardList.dart';
import 'Widgets/Task widgets/TaskList.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializeSettings() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializeAndroid = AndroidInitializationSettings("res_app_icon");
  var initializeIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(android: initializeAndroid, iOS: initializeIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() {
  initializeSettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey.shade800,
    ));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          unselectedWidgetColor: Colors.white,
        ),
        initialRoute: '/week',
        routes: {
          '/week': (context) => WeekDetails(),
          '/habits': (context) => CardList(noteType: NoteType.Habit),
          '/tasks': (context) => TaskList(),
          '/goals': (context) => CardList(noteType: NoteType.Goal),
        });
  }
}
