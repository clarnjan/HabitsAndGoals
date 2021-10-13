import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Widgets/DialogButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HabitCard.dart';

class SelectHabitsDialog extends StatefulWidget {
  final List<Habit> habits;
  final Function selectHabit;

  const SelectHabitsDialog({Key? key, required this.selectHabit, required this.habits}) : super(key: key);

  @override
  _SelectHabitsDialogState createState() => _SelectHabitsDialogState();
}

class _SelectHabitsDialogState extends State<SelectHabitsDialog> {
  @override
  Widget build(BuildContext context) {
    return widget.habits.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: widget.habits.length,
            itemBuilder: (context, index) {
              final habit = widget.habits[index];
              return Container(
                child: HabitCard(
                  habitId: habit.id!,
                  tapFunction: () {
                    widget.selectHabit(habit);
                  },
                ),
              );
            })
        : Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "All habits already added in this week.\nGo to habits to add more",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
