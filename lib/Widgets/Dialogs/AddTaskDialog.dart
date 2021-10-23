import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:numberpicker/numberpicker.dart';

import 'AddOrSelectDialog.dart';

class AddTaskDialog extends StatefulWidget {
  final int? weekId;
  final int? goalId;
  final int? taskId;
  final Function refreshParent;
  final AddEditItemController controller;

  const AddTaskDialog({Key? key, this.weekId, required this.refreshParent, required this.controller, this.goalId, this.taskId})
      : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState(controller);
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late Task task;
  bool isLoading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  _AddTaskDialogState(AddEditItemController _controller) {
    _controller.onSave = onSave;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    if (widget.taskId != null) {
      task = await DatabaseHelper.instance.getTask(widget.taskId!);
    } else {
      task = new Task();
    }
    setState(() {
      isLoading = false;
    });
  }

  onSave() async {
    if (formKey.currentState!.validate()) {
      task.createdTime = DateTime.now();
      if (task.id != null) {
        await DatabaseHelper.instance.updateTask(task);
      } else {
        task.goalFK = widget.goalId;
        task = await DatabaseHelper.instance.createTask(task);
      }
      if (widget.weekId != null && task.id != null) {
        WeeklyTask weeklyTask = new WeeklyTask(taskFK: task.id!, weekFK: widget.weekId!, isFinished: false);
        DatabaseHelper.instance.createWeeklyTask(weeklyTask);
      }
      await widget.refreshParent();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  validator: (value) {
                    setState(() {
                      task.title = value!;
                    });
                    return value!.isNotEmpty ? null : "Title is mandatory";
                  },
                  initialValue: task.title,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      task.description = value;
                    });
                  },
                  initialValue: task.description,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Effort: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Tooltip(
                          preferBelow: false,
                          showDuration: Duration(seconds: 5),
                          message: "The effort you need to put in to complete this task",
                          textStyle: TextStyle(color: Colors.lightGreenAccent),
                          padding: EdgeInsets.all(7),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.lightGreenAccent,
                            size: 19,
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                        ),
                      ],
                    ),
                    Container(
                      child: NumberPicker(
                        value: task.effort,
                        minValue: 0,
                        maxValue: 99,
                        onChanged: (value) => setState(() => task.effort = value),
                        itemWidth: 40,
                        itemHeight: 30,
                        axis: Axis.horizontal,
                        selectedTextStyle: TextStyle(
                          fontSize: 15,
                          color: CupertinoColors.activeGreen,
                          fontWeight: FontWeight.bold,
                        ),
                        textStyle: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Benefit: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Tooltip(
                          preferBelow: false,
                          showDuration: Duration(seconds: 5),
                          message: "The benefit you get after completing this task",
                          textStyle: TextStyle(color: Colors.lightGreenAccent),
                          padding: EdgeInsets.all(7),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.lightGreenAccent,
                            size: 19,
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                        ),
                      ],
                    ),
                    NumberPicker(
                      value: task.benefit,
                      minValue: 0,
                      maxValue: 99,
                      onChanged: (value) => setState(() => task.benefit = value),
                      itemWidth: 40,
                      itemHeight: 30,
                      axis: Axis.horizontal,
                      selectedTextStyle: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.activeGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      textStyle: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Reoccurring: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Tooltip(
                          preferBelow: false,
                          showDuration: Duration(seconds: 5),
                          message: "Will the task occur in more than one week?",
                          textStyle: TextStyle(color: Colors.lightGreenAccent),
                          padding: EdgeInsets.all(7),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.lightGreenAccent,
                            size: 19,
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: FlutterSwitch(
                        width: 50,
                        height: 25,
                        toggleSize: 20,
                        padding: 2,
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey.shade600,
                        value: task.isRepeating,
                        onToggle: (value) {
                          setState(() {
                            task.isRepeating = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
