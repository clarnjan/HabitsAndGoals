import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:numberpicker/numberpicker.dart';

class AddHabitDialog extends StatefulWidget {
  final Habit? habit;
  final Function refreshParent;

  const AddHabitDialog({Key? key, this.habit, required this.refreshParent})
      : super(key: key);

  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  String? title;
  int inputSingle = 1;
  int outputSingle = 1;
  int repetitions = 1;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

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
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Repetitions: "),
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
                  textStyle: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Divider(
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Input: "),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: NumberPicker(
                    value: inputSingle,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) => setState(() => inputSingle = value),
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
                  value: outputSingle,
                  minValue: 0,
                  maxValue: 100,
                  onChanged: (value) => setState(() => outputSingle = value),
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
        TextButton(
          child: Text("Add"),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              Habit habit = Habit(
                title: title!,
                inputSingle: inputSingle,
                outputSingle: outputSingle,
                repetitions: repetitions,
                isPaused: false,
                createdTime: DateTime.now(),
              );

              habit = await DatabaseHelper.instance.createHabit(habit);
              List<Week> weeks = await DatabaseHelper.instance.getAllWeeks();
              for (int i = 0; i < weeks.length; i++) {
                if (weeks[i].endDate.isAfter(habit.createdTime)) {
                  WeeklyHabit weeklyHabit = new WeeklyHabit(habitFK: habit.id!, weekFK: weeks[i].id!, repetitionsDone: 0);
                  DatabaseHelper.instance.createWeeklyHabit(weeklyHabit);
                }
              }
              await widget.refreshParent();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
