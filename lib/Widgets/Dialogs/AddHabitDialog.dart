import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Widgets/Dialogs/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:numberpicker/numberpicker.dart';

class AddHabitDialog extends StatefulWidget {
  final int? weekId;
  final Function refreshParent;
  final AddItemController controller;

  const AddHabitDialog({Key? key, this.weekId, required this.refreshParent, required this.controller}) : super(key: key);

  @override
  _AddHabitDialogState createState() => _AddHabitDialogState(controller);
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  String? title;
  String? description;
  int effortSingle = 1;
  int benefitSingle = 1;
  int repetitions = 1;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  _AddHabitDialogState(AddItemController _controller) {
    _controller.onSave = onSave;
  }

  onSave() async {
    if (formKey.currentState!.validate()) {
      Habit habit = Habit(
        title: title!,
        description: description,
        effortSingle: effortSingle,
        benefitSingle: benefitSingle,
        repetitions: repetitions,
        isPaused: false,
        createdTime: DateTime.now(),
      );

      habit = await DatabaseHelper.instance.createHabit(habit);
      if (widget.weekId != null && habit.id != null) {
        List<bool> days = [];
        for (int i = 0; i < habit.repetitions; i++) {
          days.add(false);
        }
        WeeklyHabit weeklyHabit = new WeeklyHabit(habitFK: habit.id!, weekFK: widget.weekId!, repetitionsDone: 0, days: days);
        DatabaseHelper.instance.createWeeklyHabit(weeklyHabit);
      }
      await widget.refreshParent();
      Navigator.pop(context);
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
              label: Text(
                "Title",
                style: TextStyle(
                  color: Colors.white,
                ),
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
              label: Text(
                "Description",
                style: TextStyle(
                  color: Colors.white,
                ),
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
              Row(
                children: [
                  Text(
                    "Repetitions: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Tooltip(
                    preferBelow: false,
                    showDuration: Duration(seconds: 5),
                    message: "How many times will you be doing this habit in a week",
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
                value: repetitions,
                minValue: 1,
                maxValue: 7,
                onChanged: (value) => setState(() => repetitions = value),
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
          Divider(),
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
                    message: "The effort you need to put in to do a single repetition",
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
                margin: EdgeInsets.only(top: 5),
                child: NumberPicker(
                  value: effortSingle,
                  minValue: 0,
                  maxValue: 99,
                  onChanged: (value) => setState(() => effortSingle = value),
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
                    message: "The benefit you get after a single repetition",
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
                value: benefitSingle,
                minValue: 0,
                maxValue: 99,
                onChanged: (value) => setState(() => benefitSingle = value),
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
