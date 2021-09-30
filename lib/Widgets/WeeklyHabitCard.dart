import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
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
    setState(() {
      isLoading = true;
    });
    habit = await DatabaseHelper.instance.getHabit(widget.habitId);
    weeklyHabit = await DatabaseHelper.instance.getWeklyHabit(widget.weekId, widget.habitId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[600],
        ),
        constraints: BoxConstraints(minHeight: 70),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width - 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              habit.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "${habit.inputSingle.toString()} - ${habit.outputSingle.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < weeklyHabit.days.length; i++)
                          Container(
                            width: 25,
                            height: 25,
                            padding: EdgeInsets.all(0),
                            child: Checkbox(
                                value: weeklyHabit.days[i],
                                onChanged: (value) {
                                  setState(() {
                                    weeklyHabit.days[i] = value!;
                                    DatabaseHelper.instance.updateWeeklyHabit(weeklyHabit);
                                  });
                                }),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
