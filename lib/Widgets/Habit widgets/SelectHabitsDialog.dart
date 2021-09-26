import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Widgets/DialogButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HabitCard.dart';

class SelectHabitsDialog extends StatefulWidget {
  final Week week;
  final Function refreshParent;

  const SelectHabitsDialog({Key? key, required this.week, required this.refreshParent}) : super(key: key);

  @override
  _SelectHabitsDialogState createState() => _SelectHabitsDialogState();
}

class _SelectHabitsDialogState extends State<SelectHabitsDialog> {
  late List<Habit> habits;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    this.habits = await DatabaseHelper.instance.getAllHabits();
    for (WeeklyHabit wh in widget.week.habits) {
      this.habits.removeWhere((element) => element.id == wh.habitFK);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: EdgeInsets.all(10),
      backgroundColor: Colors.grey[800],
      content: Container(
        height: MediaQuery.of(context).size.height / 1.6,
        width: MediaQuery.of(context).size.width / 1.4,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : habits.isNotEmpty
                ? ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      return Container(
                        child: HabitCard(
                          habitId: habit.id!,
                          refreshParent: refresh,
                          isSelectable: true,
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
                  ),
      ),
      actions: [
        DialogButtons(
          cancelText: "Cancel",
          submitText: "Save",
          refreshParent: widget.refreshParent,
          submitFunction: () {},
        ),
      ],
    );
  }
}
