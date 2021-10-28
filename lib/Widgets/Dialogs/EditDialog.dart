import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Tables/Goal.dart';
import 'package:diplomska1/Classes/Tables/Habit.dart';
import 'package:diplomska1/Classes/Tables/Task.dart';
import 'package:diplomska1/Widgets/Dialogs/AddOrEditGoalDialog.dart';
import 'package:diplomska1/Widgets/Dialogs/AddOrEditHabitDialog.dart';
import 'package:diplomska1/Widgets/Dialogs/AddOrEditTaskDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Shared widgets/DialogButtons.dart';
import 'AddOrSelectDialog.dart';

//Дијалог за едитирање и бришење на ставка
class EditDialog extends StatefulWidget {
  final int itemId;
  final Function refreshParent;
  final Function afterDelete;
  final NoteType noteType;

  const EditDialog(
      {Key? key,
      required this.itemId,
      required this.refreshParent,
      required this.noteType,
      required this.afterDelete})
      : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late Habit habit;
  late Task task;
  late Goal goal;
  bool isLoading = true;
  bool isDeleting = false;
  final AddEditItemController _controller = AddEditItemController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //Земање на иницијални податоци од базата
  fetchData() async {
    setState(() {
      isLoading = true;
    });
    switch (widget.noteType) {
      case NoteType.Habit:
        habit = await DatabaseHelper.instance.getHabit(widget.itemId);
        break;
      case NoteType.Task:
        task = await DatabaseHelper.instance.getTask(widget.itemId);
        break;
      case NoteType.Goal:
        goal = await DatabaseHelper.instance.getGoal(widget.itemId);
        break;
    }
    setState(() {
      isLoading = false;
    });
  }

  mainButtonClick() {
    _controller.onSave();
  }

  //Клик на копчето Delete
  secondButtonClick(BuildContext context) async {
    setState(() {
      isDeleting = true;
    });
  }

  //Бришење на ставка од базата
  delete() async {
    switch (widget.noteType) {
      case NoteType.Habit:
        await DatabaseHelper.instance.deleteHabit(widget.itemId);
        break;
      case NoteType.Task:
        await DatabaseHelper.instance.deleteTask(widget.itemId);
        break;
      case NoteType.Goal:
        await DatabaseHelper.instance.deleteGoal(widget.itemId);
        break;
    }
    Navigator.pop(context);
    await widget.afterDelete();
  }

  //Наслов на дијалогот
  String getTitle() {
    if (isLoading) {
      return "Loading";
    }
    switch (widget.noteType) {
      case NoteType.Habit:
        return "Edit habit";
      case NoteType.Task:
        return "Edit task";
      case NoteType.Goal:
        return "Edit goal";
    }
  }

  //Наслов на Delete дијалогот
  String getDeleteTitle() {
    if (isLoading) {
      return "Loading";
    }
    switch (widget.noteType) {
      case NoteType.Habit:
        return "Are you sure you want to delete \"${habit.title}\"?";
      case NoteType.Task:
        return "Are you sure you want to delete \"${task.title}\"?";
      case NoteType.Goal:
        return "Are you sure you want to delete \"${goal.title}\"?";
    }
  }

  //Метод кој го враќа дијалогот во завистност од типот на ставката
  Widget getDialog() {
    switch (widget.noteType) {
      case NoteType.Habit:
        return AddOrEditHabitDialog(
          refreshParent: widget.refreshParent,
          habitId: habit.id,
          controller: _controller,
        );
      case NoteType.Task:
        return AddOrEditTaskDialog(
          refreshParent: widget.refreshParent,
          taskId: task.id,
          controller: _controller,
        );
      case NoteType.Goal:
        return AddOrEditGoalDialog(
          refreshParent: widget.refreshParent,
          goalId: goal.id,
          controller: _controller,
        );
    }
  }

  //Клик на копчето Cancel
  cancelDeletion(BuildContext context) {
    setState(() {
      isDeleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isDeleting
        ? AlertDialog(
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
                    child: SingleChildScrollView(
                      child: getDialog(),
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
                  mainButtonFunction: mainButtonClick,
                  showSecondButton: true,
                  secondButtonText: "Delete",
                  secondButtonFunction: secondButtonClick,
                ),
              ),
            ],
          )
        : AlertDialog(
            title: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
            titlePadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            backgroundColor: Colors.grey[800],
            content: Container(
              child: Text(
                getDeleteTitle(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            actions: [
              Container(
                child: DialogButtons(
                  mainButtonText: "Delete",
                  mainButtonFunction: delete,
                  showSecondButton: true,
                  secondButtonText: "Cancel",
                  secondButtonFunction: cancelDeletion,
                ),
              ),
            ],
          );
  }
}
