import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Widgets/DialogButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddHabitDialog.dart';
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
  List<Habit> selectedHabits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
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

  selectHabit(Habit habit) {
    if (selectedHabits.contains(habit)) {
      selectedHabits.remove(habit);
    } else {
      selectedHabits.add(habit);
    }
  }

  save() async {
    for (Habit habit in selectedHabits) {
      if (!widget.week.habits.any((element) => element.habitFK == habit.id)) {
        if (habit.id == null) {
          throw Exception("Habit id is null");
        }
        if (widget.week.id == null) {
          throw Exception("Week id is null");
        } else {
          List<bool> days = [];
          for (int i = 0; i < habit.repetitions; i++) {
            days.add(false);
          }
          WeeklyHabit weeklyHabit =
              new WeeklyHabit(habitFK: habit.id!, weekFK: widget.week.id!, repetitionsDone: 0, days: days);
          DatabaseHelper.instance.createWeeklyHabit(weeklyHabit);
        }
      }
    }
    await widget.refreshParent();
    Navigator.pop(context);
  }

  Future<void> add(BuildContext context) async {
    Navigator.pop(context);
    return await showDialog(
        context: context,
        builder: (context) {
          return AddHabitDialog(refreshParent: () {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                          refreshParent: init,
                          tapFunction: () {
                            selectHabit(habit);
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
                  ),
      ),
      actions: [
        DialogButtons(
          cancelText: "Cancel",
          submitText: "Save",
          showAddButton: true,
          addFunction: add,
          refreshParent: widget.refreshParent,
          submitFunction: save,
        ),
      ],
    );
  }
}
