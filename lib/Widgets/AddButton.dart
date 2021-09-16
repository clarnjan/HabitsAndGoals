import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Widgets/Goal%20widgets/AddGoalDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Habit widgets/AddHabitDialog.dart';
import 'Task widgets/AddTaskDialog.dart';
import 'Week widgets/AddWeekDialog.dart';

class AddButton extends StatelessWidget {
  final Function refreshParent;
  final String text;
  final Position? position;
  final Color? color;
  final AddButtonType type;
  const AddButton({Key? key, required this.refreshParent, required this.text, this.position, this.color, required this.type }) : super(key: key);

  Future<void> onTap(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        if (type == AddButtonType.addWeek) {
          return AddWeekDialog(refreshParent: refreshParent);
        }
        if (type == AddButtonType.addHabit) {
          return AddHabitDialog(refreshParent: refreshParent);
        }
        if (type == AddButtonType.addGoal) {
          return AddGoalDialog(refreshParent: refreshParent);
        }
        return AddTaskDialog(refreshParent: refreshParent);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: position == Position.bottomRight? 10 : null,
      left: position == Position.bottomLeft? 10 : null,
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
                text,
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
