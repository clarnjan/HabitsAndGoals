import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatefulWidget {
  final int habitId;
  final int weekId;
  final Function tapFunction;
  final Function checkBoxChanged;

  HabitCard({required this.habitId, required this.weekId, required this.tapFunction, required this.checkBoxChanged});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  late Habit habit;
  late WeeklyHabit weeklyHabit;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    habit = await DatabaseHelper.instance.getHabit(widget.habitId);
    weeklyHabit = await DatabaseHelper.instance.getWeeklyHabit(widget.weekId, widget.habitId);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  checkChanged(int index) {
    setState(() {
      weeklyHabit.days[index] = !weeklyHabit.days[index];
      if (weeklyHabit.days[index]) {
        weeklyHabit.repetitionsDone++;
      } else {
        weeklyHabit.repetitionsDone--;
      }
      widget.checkBoxChanged(weeklyHabit.days[index], habit.effortSingle, habit.benefitSingle);
      DatabaseHelper.instance.updateWeeklyHabit(weeklyHabit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.tapFunction();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[600],
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width - 120,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 280,
                      child: Text(
                        habit.title,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (int i = 0; i < weeklyHabit.days.length; i++)
                            InkWell(
                              onTap: () {
                                checkChanged(i);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: weeklyHabit.days[i] ? Colors.green.shade700 : Colors.transparent,
                                    border: Border.all(
                                      color: weeklyHabit.days[i] ? Colors.green.shade700 : Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: weeklyHabit.days[i]
                                      ? Icon(
                                          Icons.check,
                                          size: 18.0,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          null,
                                          size: 18.0,
                                        ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${habit.effortSingle.toString()} - ${habit.benefitSingle.toString()}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
