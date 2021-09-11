import 'package:diplomska1/Classes/Habit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitDetails extends StatefulWidget {
  final Habit habit;
  const HabitDetails(this.habit, {Key? key}) : super(key: key);

  @override
  _HabitDetailsState createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(widget.habit.title),
          ],
        ),
      ),
    );
  }
}
