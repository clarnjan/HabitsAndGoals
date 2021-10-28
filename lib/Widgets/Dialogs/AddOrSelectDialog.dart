import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Tables/Goal.dart';
import 'package:diplomska1/Classes/Tables/Habit.dart';
import 'package:diplomska1/Classes/Tables/Task.dart';
import 'package:diplomska1/Classes/Tables/Week.dart';
import 'package:diplomska1/Classes/Tables/WeeklyHabit.dart';
import 'package:diplomska1/Classes/Tables/WeeklyTask.dart';
import 'package:diplomska1/Widgets/Dialogs/AddOrEditGoalDialog.dart';
import 'package:diplomska1/Widgets/Dialogs/AddOrEditTaskDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Shared widgets/DialogButtons.dart';
import 'AddOrEditHabitDialog.dart';
import 'SelectHabitsDialog.dart';
import 'SelectTasksDialog.dart';

class AddEditItemController {
  late void Function() onSave;
}

//Дијалог за додавање или селектирање на ставки
class AddOrSelectDialog extends StatefulWidget {
  final int? weekId;
  final int? goalId;
  final Function refreshParent;
  final bool canSelect;
  final NoteType noteType;

  const AddOrSelectDialog(
      {Key? key,
      this.weekId,
      required this.refreshParent,
      required this.canSelect,
      required this.noteType,
      this.goalId})
      : super(key: key);

  @override
  _AddOrSelectDialogState createState() => _AddOrSelectDialogState();
}

class _AddOrSelectDialogState extends State<AddOrSelectDialog> {
  late Week week;
  late Goal goal;
  List<Habit> habits = [];
  List<Habit> selectedHabits = [];
  List<Task> tasks = [];
  List<Task> selectedTasks = [];
  bool isLoading = false;
  bool isSelecting = false;
  final AddEditItemController _controller = AddEditItemController();

  @override
  void initState() {
    super.initState();
  }

  //Земање на иницијални податоци од базата
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
          final allTasks = await DatabaseHelper.instance.getAllTasks();
          tasks = [];
          for (Task t in allTasks) {
            if (week.tasks.where((wt) => wt.taskFK == t.id).isEmpty &&
                t.weekFK == null) {
              tasks.add(t);
            }
          }
        }
      } else if (widget.goalId != null) {
        goal = await DatabaseHelper.instance.getGoal(widget.goalId!);
        tasks = await DatabaseHelper.instance.getAllTasks();
        tasks.removeWhere(
            (element) => element.goalFK != null || element.isRepeating);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  //Селектирање на навика
  selectHabit(Habit habit) {
    if (selectedHabits.contains(habit)) {
      selectedHabits.remove(habit);
    } else {
      selectedHabits.add(habit);
    }
  }

  //Селектирање на задача
  selectTask(Task task) {
    if (selectedTasks.contains(task)) {
      selectedTasks.remove(task);
    } else {
      selectedTasks.add(task);
    }
  }

  //Клик на копчето Save
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
            WeeklyHabit weeklyHabit = new WeeklyHabit(
                habitFK: habit.id!,
                weekFK: widget.weekId!,
                repetitionsDone: 0,
                days: days);
            await DatabaseHelper.instance.createWeeklyHabit(weeklyHabit);
          }
        }
      } else if (widget.weekId != null && widget.noteType == NoteType.Task) {
        for (Task task in selectedTasks) {
          if (!week.tasks.any((element) => element.taskFK == task.id)) {
            if (task.id == null) {
              throw Exception("Task id is null");
            }
            if (!task.isRepeating) {
              task.weekFK = widget.weekId;
              await DatabaseHelper.instance.updateTask(task);
            }
            WeeklyTask weeklyTask = new WeeklyTask(
                taskFK: task.id!, weekFK: widget.weekId!, isFinished: false);
            weeklyTask =
                await DatabaseHelper.instance.createWeeklyTask(weeklyTask);
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

  //Клик на Select/New копчето
  toggleButton(BuildContext context) async {
    setState(() {
      isSelecting = !isSelecting;
    });
    if (isSelecting && habits.isEmpty && tasks.isEmpty) fetchData();
  }

  //Метод кој го враќа дијалогот во завистност од типот на ставката
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

  //Метод кој го враќа дијалогот во завистност од типот на ставката
  Widget getAddDialog() {
    switch (widget.noteType) {
      case NoteType.Habit:
        return AddOrEditHabitDialog(
          weekId: widget.weekId,
          controller: _controller,
          refreshParent: widget.refreshParent,
        );
      case NoteType.Task:
        return AddOrEditTaskDialog(
          weekId: widget.weekId,
          goalId: widget.goalId,
          controller: _controller,
          refreshParent: widget.refreshParent,
        );
      case NoteType.Goal:
        return AddOrEditGoalDialog(
          weekId: widget.weekId,
          controller: _controller,
          refreshParent: widget.refreshParent,
        );
    }
  }

  //Наслов на дијалогот
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
    result += isSelecting ? "s to add" : "";
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      backgroundColor: Colors.grey[800],
      content: !isLoading
          ? Container(
              constraints: BoxConstraints(
                minHeight: 200,
                maxHeight: MediaQuery.of(context).size.height / 1.6,
              ),
              width: MediaQuery.of(context).size.width / 1.4,
              child: widget.canSelect &&
                      (widget.weekId != null || widget.goalId != null) &&
                      isSelecting
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: getSelectDialog(),
                    )
                  : getAddDialog(),
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
