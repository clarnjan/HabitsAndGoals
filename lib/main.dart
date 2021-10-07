import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Widgets/Week%20widgets/WeekDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Widgets/CardList.dart';

void main() {
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
          '/habits': (context) => CardList(cardListType: CardListType.Habits),
          '/tasks': (context) => CardList(cardListType: CardListType.Tasks),
          '/goals': (context) => CardList(cardListType: CardListType.Goals),
        });
  }
}
