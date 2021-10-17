import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeeklyHabitCard extends StatefulWidget {
  final int habitId;
  final int weekId;

  WeeklyHabitCard({required this.habitId, required this.weekId});

  @override
  _WeeklyHabitCardState createState() => _WeeklyHabitCardState();
}

class _WeeklyHabitCardState extends State<WeeklyHabitCard> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              setState(() {
                                weeklyHabit.days[i] = !weeklyHabit.days[i];
                                DatabaseHelper.instance.updateWeeklyHabit(weeklyHabit);
                              });
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
                        "${habit.inputSingle.toString()} - ${habit.outputSingle.toString()}",
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
    );
  }
}
