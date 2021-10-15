import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'CustomDialog.dart';

class AddTaskDialog extends StatefulWidget {
  final int? weekId;
  final Function refreshParent;
  final AddItemController controller;

  const AddTaskDialog({Key? key, this.weekId, required this.refreshParent, required this.controller}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState(controller);
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String? title;
  String? description;
  int input = 1;
  int output = 1;
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
        input: input,
        output: output,
        isRepeating: false,
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
                color: Colors.grey[300],
              ),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
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
                color: Colors.grey[300],
              ),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Input: ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Container(
                child: NumberPicker(
                  value: input,
                  minValue: 0,
                  maxValue: 100,
                  onChanged: (value) => setState(() => input = value),
                  itemWidth: 40,
                  itemHeight: 30,
                  axis: Axis.horizontal,
                  selectedTextStyle: TextStyle(
                    fontSize: 18,
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
              Text(
                "Output: ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              NumberPicker(
                value: output,
                minValue: 0,
                maxValue: 100,
                onChanged: (value) => setState(() => output = value),
                itemWidth: 40,
                itemHeight: 30,
                axis: Axis.horizontal,
                selectedTextStyle: TextStyle(
                  fontSize: 18,
                  color: CupertinoColors.activeGreen,
                  fontWeight: FontWeight.bold,
                ),
                textStyle: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
