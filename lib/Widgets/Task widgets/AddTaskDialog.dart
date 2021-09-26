import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../DialogButtons.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? task;
  final Function refreshParent;

  const AddTaskDialog({Key? key, this.task, required this.refreshParent}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String title = '';
  int input = 1;
  int output = 1;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  addTask() async {
    if (formKey.currentState!.validate()) {
      final task = Task(
        title: title,
        input: input,
        output: output,
        isRepeating: false,
        createdTime: DateTime.now(),
      );

      DatabaseHelper.instance.createTask(task);
      await widget.refreshParent();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textEditingController,
              validator: (value) {
                setState(() {
                  title = value!;
                });
                return value!.isNotEmpty ? null : "Title is mandatory";
              },
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Input: "),
                Container(
                  margin: EdgeInsets.only(top: 5),
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
                    textStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Output: "),
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
                  textStyle: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        DialogButtons(
          cancelText: "Cancel",
          submitText: "Save",
          refreshParent: widget.refreshParent,
          submitFunction: () async {
            await addTask();
          },
        ),
      ],
    );
  }
}
