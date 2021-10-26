import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Widgets/Dialogs/AddOrSelectDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:numberpicker/numberpicker.dart';

class AddOrEditHabitDialog extends StatefulWidget {
  final int? weekId;
  final int? habitId;
  final Function refreshParent;
  final AddEditItemController controller;

  const AddOrEditHabitDialog({Key? key, this.weekId, required this.refreshParent, required this.controller, this.habitId})
      : super(key: key);

  @override
  _AddOrEditHabitDialogState createState() => _AddOrEditHabitDialogState(controller);
}

class _AddOrEditHabitDialogState extends State<AddOrEditHabitDialog> {
  late Habit habit;
  bool isLoading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  _AddOrEditHabitDialogState(AddEditItemController _controller) {
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
    if (widget.habitId != null) {
      habit = await DatabaseHelper.instance.getHabit(widget.habitId!);
    } else {
      habit = new Habit();
    }
    setState(() {
      isLoading = false;
    });
  }

  onSave() async {
    if (formKey.currentState!.validate()) {
      habit.createdTime = DateTime.now();
      if (habit.id != null) {
        List<WeeklyHabit> weeklyHabits = await DatabaseHelper.instance.getWeeklyHabitsForHabit(habit.id!);
        await DatabaseHelper.instance.updateHabit(habit);
        for (WeeklyHabit wh in weeklyHabits) {
          List<bool> days = [];
          for (int i = 0; i < habit.repetitions; i++) {
            if (wh.repetitionsDone > i) {
              days.add(true);
            } else {
              days.add(false);
            }
          }
          wh.repetitionsDone = days.where((element) => element == true).length;
          wh.days = days;
          await DatabaseHelper.instance.updateWeeklyHabit(wh);
        }
      } else {
        habit = await DatabaseHelper.instance.createHabit(habit);
      }
      if (widget.weekId != null && habit.id != null) {
        List<bool> days = [];
        for (int i = 0; i < habit.repetitions; i++) {
          days.add(false);
        }
        WeeklyHabit weeklyHabit = new WeeklyHabit(habitFK: habit.id!, weekFK: widget.weekId!, repetitionsDone: 0, days: days);
        await DatabaseHelper.instance.createWeeklyHabit(weeklyHabit);
      }
      await widget.refreshParent();
      Navigator.pop(context);
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
                  autofocus: MediaQuery.of(context).size.height > 600,
                  validator: (value) {
                    setState(() {
                      habit.title = value!;
                    });
                    return value!.isNotEmpty ? null : "Title is mandatory";
                  },
                  initialValue: habit.title,
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
                      habit.description = value;
                    });
                  },
                  initialValue: habit.description,
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
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.4 / 2.3,
                        child: Wrap(
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
                      ),
                      Container(
                        child: NumberPicker(
                          value: habit.repetitions,
                          minValue: 1,
                          maxValue: 7,
                          onChanged: (value) => setState(() => habit.repetitions = value),
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
                        value: habit.effortSingle,
                        minValue: 0,
                        maxValue: 99,
                        onChanged: (value) => setState(() => habit.effortSingle = value),
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
                      value: habit.benefitSingle,
                      minValue: 0,
                      maxValue: 99,
                      onChanged: (value) => setState(() => habit.benefitSingle = value),
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
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
