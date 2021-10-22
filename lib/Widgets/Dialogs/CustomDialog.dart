import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:diplomska1/Widgets/Dialogs/AddGoalDialog.dart';
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
  final int? goalId;
  final Function refreshParent;
  final bool canSelect;
  final NoteType noteType;

  const CustomDialog({Key? key, this.weekId, required this.refreshParent, required this.canSelect, required this.noteType, this.goalId})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late Week week;
  late Goal goal;
  List<Habit> habits = [];
  List<Habit> selectedHabits = [];
  List<Task> tasks = [];
  List<Task> selectedTasks = [];
  bool isLoading = false;
  bool isSelecting = false;
  final AddItemController _controller = AddItemController();

  @override
  void initState() {
    super.initState();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    if (widget.canSelect) {
      if (widget.weekId != null) {
        if (widget.noteType == NoteType.Habit) {
          week = await DatabaseHelper.instance.getWeek(widget.weekId!);
          habits = await DatabaseHelper.instance.getAllHabits();
          for (WeeklyHabit wh in week.habits) {
            this.habits.removeWhere((element) => element.id == wh.habitFK);
          }
        } else if (widget.noteType == NoteType.Task) {
          week = await DatabaseHelper.instance.getWeek(widget.weekId!);
          tasks = await DatabaseHelper.instance.getAllTasks();
          for (WeeklyTask wt in week.tasks) {
            this.tasks.removeWhere((element) => element.id == wt.taskFK);
          }
        }
      } else if (widget.goalId != null) {
        goal = await DatabaseHelper.instance.getGoal(widget.goalId!);
        tasks = await DatabaseHelper.instance.getAllTasks();
        tasks.removeWhere((element) => element.goalFK != null);
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
      if (widget.weekId != null && widget.noteType == NoteType.Habit) {
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
      } else if (widget.weekId != null && widget.noteType == NoteType.Task) {
        for (Task task in selectedTasks) {
          if (!week.tasks.any((element) => element.taskFK == task.id)) {
            if (task.id == null) {
              throw Exception("Task id is null");
            }
            WeeklyTask weeklyTask = new WeeklyTask(taskFK: task.id!, weekFK: widget.weekId!, isFinished: false);
            weeklyTask = await DatabaseHelper.instance.createWeeklyTask(weeklyTask);
          }
        }
      } else if (widget.goalId != null) {
        for (Task task in selectedTasks) {
          if (!goal.tasks.contains(task)) {
            task.goalFK = goal.id;
            await DatabaseHelper.instance.updateTask(task);
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
    if (isSelecting && habits.isEmpty && tasks.isEmpty) fetchData();
  }

  Widget getSelectDialog() {
    switch (widget.noteType) {
      case NoteType.Habit:
        return Container(
          child: SelectHabitsDialog(
            habits: habits,
            selectHabit: selectHabit,
          ),
        );
      case NoteType.Task:
        return Container(
          child: SelectTasksDialog(
            tasks: tasks,
            selectTask: selectTask,
          ),
        );
      case NoteType.Goal:
        return Text("Nothing to select");
    }
  }

  Widget getAddDialog() {
    switch (widget.noteType) {
      case NoteType.Habit:
        return AddHabitDialog(
          weekId: widget.weekId,
          controller: _controller,
          refreshParent: widget.refreshParent,
        );
      case NoteType.Task:
        return AddTaskDialog(
          weekId: widget.weekId,
          goalId: widget.goalId,
          controller: _controller,
          refreshParent: widget.refreshParent,
        );
      case NoteType.Goal:
        return AddGoalDialog(
          weekId: widget.weekId,
          controller: _controller,
          refreshParent: widget.refreshParent,
        );
    }
  }

  String getTitle() {
    String result = isSelecting ? "Select " : "Add a new ";
    switch (widget.noteType) {
      case NoteType.Habit:
        result += "habit";
        break;
      case NoteType.Task:
        result += "task";
        break;
      case NoteType.Goal:
        result += "goal";
        break;
    }
    result += isSelecting ? "s" : "";
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        width: double.infinity,
        child: Center(
          child: Text(
            getTitle(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      titlePadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      backgroundColor: Colors.grey[800],
      content: !isLoading
          ? Container(
              constraints: BoxConstraints(
                minHeight: 200,
                maxHeight: MediaQuery.of(context).size.height / 1.6,
              ),
              width: MediaQuery.of(context).size.width / 1.4,
              child: SingleChildScrollView(
                child: widget.canSelect && (widget.weekId != null || widget.goalId != null) && isSelecting
                    ? getSelectDialog()
                    : getAddDialog(),
              ),
            )
          : Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
      actions: [
        Container(
          child: DialogButtons(
            mainButtonText: "Save",
            secondButtonText: isSelecting ? "New" : "Select",
            showSecondButton: widget.canSelect,
            secondButtonFunction: toggleButton,
            mainButtonFunction: save,
          ),
        ),
      ],
    );
  }
}
