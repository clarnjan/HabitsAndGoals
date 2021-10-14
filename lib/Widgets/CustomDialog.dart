import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DialogButtons.dart';
import 'Habit widgets/AddHabitDialog.dart';
import 'Habit widgets/SelectHabitsDialog.dart';

class AddHabitController {
  late void Function() onSave;
}

class CustomDialog extends StatefulWidget {
  final int? weekId;
  final Function refreshParent;
  final bool canSelect;

  const CustomDialog({Key? key, this.weekId, required this.refreshParent, required this.canSelect}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late Week week;
  late List<Habit> habits;
  List<Habit> selectedHabits = [];
  bool isLoading = true;
  bool isSelecting = false;
  final AddHabitController _controller = AddHabitController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    if (widget.canSelect && widget.weekId != null) {
      isSelecting = true;
      week = await DatabaseHelper.instance.getWeek(widget.weekId!);
      this.habits = await DatabaseHelper.instance.getAllHabits();
      for (WeeklyHabit wh in week.habits) {
        this.habits.removeWhere((element) => element.id == wh.habitFK);
      }
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
    if (widget.canSelect && isSelecting) {
      for (Habit habit in selectedHabits) {
        if (!week.habits.any((element) => element.habitFK == habit.id)) {
          if (habit.id == null) {
            throw Exception("Habit id is null");
          }
          List<bool> days = [];
          for (int i = 0; i < habit.repetitions; i++) {
            days.add(false);
          }
          WeeklyHabit weeklyHabit = new WeeklyHabit(habitFK: habit.id!, weekFK: widget.weekId!, repetitionsDone: 0, days: days);
          DatabaseHelper.instance.createWeeklyHabit(weeklyHabit);
        }
      }
      await widget.refreshParent();
      Navigator.pop(context);
    } else {
      _controller.onSave();
    }
  }

  toggleButton(BuildContext context) async {
    setState(() {
      isSelecting = !isSelecting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      backgroundColor: Colors.grey[800],
      content: !isLoading
          ? Container(
              constraints: BoxConstraints(
                minHeight: 200,
                maxHeight: MediaQuery.of(context).size.height / 1.6,
              ),
              width: MediaQuery.of(context).size.width / 1.4,
              child: widget.canSelect && widget.weekId != null && isSelecting
                  ? Container(
                      child: SelectHabitsDialog(
                        habits: habits,
                        selectHabit: selectHabit,
                      ),
                    )
                  : AddHabitDialog(
                      weekId: widget.weekId,
                      controller: _controller,
                      refreshParent: widget.refreshParent,
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      actions: [
        Container(
          child: DialogButtons(
            cancelButtonText: "Cancel",
            submitButtonText: "Save",
            newButtonText: isSelecting ? "New" : "Select",
            showAddButton: widget.canSelect,
            addFunction: toggleButton,
            refreshParent: widget.refreshParent,
            submitFunction: save,
          ),
        ),
      ],
    );
  }
}
