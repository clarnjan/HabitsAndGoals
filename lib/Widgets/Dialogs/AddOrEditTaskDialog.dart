import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/DateService.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:diplomska1/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

import 'AddOrSelectDialog.dart';

class AddOrEditTaskDialog extends StatefulWidget {
  final int? weekId;
  final int? goalId;
  final int? taskId;
  final Function refreshParent;
  final AddEditItemController controller;

  const AddOrEditTaskDialog({Key? key, this.weekId, required this.refreshParent, required this.controller, this.goalId, this.taskId})
      : super(key: key);

  @override
  _AddOrEditTaskDialogState createState() => _AddOrEditTaskDialogState(controller);
}

class _AddOrEditTaskDialogState extends State<AddOrEditTaskDialog> {
  late Task task;
  bool isLoading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey repetitionTooltipKey = GlobalKey();
  _AddOrEditTaskDialogState(AddEditItemController _controller) {
    _controller.onSave = onSave;
  }

  @override
  void initState() {
    super.initState();
    initializeTimeZones();
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
        if (widget.goalId != null) {
          task.goalFK = widget.goalId;
        }
        if (widget.weekId != null) {
          task.weekFK = widget.weekId;
        }
        task = await DatabaseHelper.instance.createTask(task);
      }
      if (task.reminderTime != null && task.id != null) {
        displayNotification();
      }
      if (widget.weekId != null && task.id != null) {
        WeeklyTask weeklyTask = new WeeklyTask(taskFK: task.id!, weekFK: widget.weekId!, isFinished: false);
        DatabaseHelper.instance.createWeeklyTask(weeklyTask);
      }
      await widget.refreshParent();
      Navigator.of(context).pop();
    }
  }

  Future<void> displayNotification() async {
    flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!,
        "Reminder",
        "Reminder for ${task.title}",
        tz.TZDateTime.from(task.reminderTime!, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails('channel id', 'channel body'),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null) {
      final initalTime = TimeOfDay(hour: 9, minute: 0);
      final time = await showTimePicker(context: context, initialTime: initalTime);
      if (time != null) {
        setState(() {
          task.reminderTime = picked.add(Duration(hours: time.hour, minutes: time.minute));
        });
      }
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
                  autofocus: MediaQuery.of(context).size.height > 720,
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
                    Row(
                      children: [
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
                              if (task.id == null && widget.goalId == null) {
                                setState(() {
                                  task.isRepeating = value;
                                });
                              } else {
                                final dynamic tooltip = repetitionTooltipKey.currentState;
                                tooltip.ensureTooltipVisible();
                              }
                            },
                          ),
                        ),
                        Tooltip(
                          key: repetitionTooltipKey,
                          preferBelow: false,
                          showDuration: Duration(seconds: 3),
                          message:
                              widget.goalId == null ? "Cannot change task's reoccurring value" : "Cannot add a reoccurring task to a goal",
                          textStyle: TextStyle(color: Colors.lightGreenAccent),
                          padding: EdgeInsets.all(7),
                          child: Icon(
                            Icons.info_outline,
                            size: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!task.isRepeating) Divider(),
                if (!task.isRepeating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reminder: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        width: 150,
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(task.reminderTime != null ? DateService.formatDateAndTime(task.reminderTime!) : "Add a reminder"),
                        ),
                      )
                    ],
                  )
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
