import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Widgets/Goal%20widgets/AddGoalDialog.dart';
import 'package:diplomska1/Widgets/Habit%20widgets/SelectHabitsDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Habit widgets/AddHabitDialog.dart';
import 'Task widgets/AddTaskDialog.dart';

class FloatingButton extends StatelessWidget {
  final Function refreshParent;
  final Position? position;
  final Color? color;
  final FloatingButtonType type;
  final Week? week;
  const FloatingButton({Key? key, required this.refreshParent, this.position, this.color, required this.type, this.week}) : super(key: key);

  Future<void> onTap(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        switch (type) {
          case FloatingButtonType.addTask:
            return AddTaskDialog(refreshParent: refreshParent);
          case FloatingButtonType.addHabit:
            return AddHabitDialog(refreshParent: refreshParent);
          case FloatingButtonType.addGoal:
            return AddGoalDialog(refreshParent: refreshParent);
          case FloatingButtonType.selectTasks:
          // TODO: Handle this case.
          case FloatingButtonType.selectHabits:
            if (week != null) {
              return SelectHabitsDialog(
                week: week!,
                refreshParent: refreshParent,
              );
            } else {
              throw Exception("Week must be provided for selecting habits");
            }
        }
      },
    );
  }

  String getTitle() {
    switch (type) {
      case FloatingButtonType.addTask:
        return "Add Task";
      case FloatingButtonType.addHabit:
        return "Add Habit";
      case FloatingButtonType.addGoal:
        return "Add Goal";
      case FloatingButtonType.selectTasks:
        return "Select Tasks";
      case FloatingButtonType.selectHabits:
        return "Select Habits";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: position == Position.bottomRight ? 10 : null,
      left: position == Position.bottomLeft ? 10 : null,
      child: GestureDetector(
        onTap: () async {
          await onTap(context);
        },
        child: Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                getTitle(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: color ?? Colors.green[700],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
