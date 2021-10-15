import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:diplomska1/Widgets/Dialogs/AddTaskDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../DialogButtons.dart';
import 'AddHabitDialog.dart';
import 'SelectHabitsDialog.dart';
import 'SelectTasksDialog.dart';

class AddItemController {
  late void Function() onSave;
}

class CustomDialog extends StatefulWidget {
  final int? weekId;
  final Function refreshParent;
  final bool canSelect;
  final NoteType noteType;

  const CustomDialog({Key? key, this.weekId, required this.refreshParent, required this.canSelect, required this.noteType})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late Week week;
  late List<Habit> habits;
  List<Habit> selectedHabits = [];
  late List<Task> tasks;
  List<Task> selectedTasks = [];
  bool isLoading = true;
  bool isSelecting = false;
  final AddItemController _controller = AddItemController();

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
      if (widget.noteType == NoteType.Habit) {
        isSelecting = true;
        week = await DatabaseHelper.instance.getWeek(widget.weekId!);
        this.habits = await DatabaseHelper.instance.getAllHabits();
        for (WeeklyHabit wh in week.habits) {
          this.habits.removeWhere((element) => element.id == wh.habitFK);
        }
      } else if (widget.noteType == NoteType.Task) {
        isSelecting = true;
        week = await DatabaseHelper.instance.getWeek(widget.weekId!);
        this.tasks = await DatabaseHelper.instance.getAllTasks();
        for (WeeklyTask wt in week.tasks) {
          this.tasks.removeWhere((element) => element.id == wt.taskFK);
        }
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

  selectTask(Task task) {
    if (selectedTasks.contains(task)) {
      selectedTasks.remove(task);
    } else {
      selectedTasks.add(task);
    }
  }

  save() async {
    if (widget.canSelect && isSelecting) {
      if (widget.noteType == NoteType.Habit) {
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
      } else if (widget.noteType == NoteType.Task) {
        for (Task task in selectedTasks) {
          if (!week.tasks.any((element) => element.taskFK == task.id)) {
            if (task.id == null) {
              throw Exception("Habit id is null");
            }
            WeeklyTask weeklyTask = new WeeklyTask(taskFK: task.id!, weekFK: widget.weekId!, isFinished: false);
            weeklyTask = await DatabaseHelper.instance.createWeeklyTask(weeklyTask);
          }
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

  Widget getSelectDialog() {
    if (widget.noteType == NoteType.Habit)
      return Container(
        child: SelectHabitsDialog(
          habits: habits,
          selectHabit: selectHabit,
        ),
      );
    //if (widget.noteType == NoteType.Task)
    return Container(
      child: SelectTasksDialog(
        tasks: tasks,
        selectTask: selectTask,
      ),
    );
  }

  Widget getAddDialog() {
    if (widget.noteType == NoteType.Habit)
      return AddHabitDialog(
        weekId: widget.weekId,
        controller: _controller,
        refreshParent: widget.refreshParent,
      );
    //if (widget.noteType == NoteType.Task)
    return AddTaskDialog(
      weekId: widget.weekId,
      controller: _controller,
      refreshParent: widget.refreshParent,
    );
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
              child: widget.canSelect && widget.weekId != null && isSelecting ? getSelectDialog() : getAddDialog(),
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
