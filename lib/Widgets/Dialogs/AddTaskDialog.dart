import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:numberpicker/numberpicker.dart';

import 'CustomDialog.dart';

class AddTaskDialog extends StatefulWidget {
  final int? weekId;
  final int? goalId;
  final Function refreshParent;
  final AddItemController controller;

  const AddTaskDialog({Key? key, this.weekId, required this.refreshParent, required this.controller, this.goalId}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState(controller);
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String? title;
  String? description;
  bool isRepeating = false;
  int effort = 1;
  int benefit = 1;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  _AddTaskDialogState(AddItemController _controller) {
    _controller.onSave = onSave;
  }

  onSave() async {
    if (formKey.currentState!.validate()) {
      Task task = Task(
        title: title!,
        description: description,
        effort: effort,
        benefit: benefit,
        goalFK: widget.goalId,
        isRepeating: isRepeating,
        isFinished: false,
        createdTime: DateTime.now(),
      );

      task = await DatabaseHelper.instance.createTask(task);
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
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            autofocus: true,
            controller: textEditingController,
            validator: (value) {
              setState(() {
                title = value!;
              });
              return value!.isNotEmpty ? null : "Title is mandatory";
            },
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
          TextField(
            onChanged: (value) {
              setState(() {
                description = value;
              });
            },
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
                  value: effort,
                  minValue: 0,
                  maxValue: 99,
                  onChanged: (value) => setState(() => effort = value),
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
                value: benefit,
                minValue: 0,
                maxValue: 99,
                onChanged: (value) => setState(() => benefit = value),
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
                  value: isRepeating,
                  onToggle: (value) {
                    setState(() {
                      isRepeating = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
