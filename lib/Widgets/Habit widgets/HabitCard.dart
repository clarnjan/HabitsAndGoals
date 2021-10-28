import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Tables/Habit.dart';
import 'package:diplomska1/Classes/Tables/WeeklyHabit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Картичка со информации за дадена навика
class HabitCard extends StatefulWidget {
  final Habit habit;
  final WeeklyHabit weeklyHabit;
  final Function tapFunction;
  final Function checkBoxChanged;

  HabitCard(
      {required this.habit,
      required this.weeklyHabit,
      required this.tapFunction,
      required this.checkBoxChanged});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  @override
  void initState() {
    super.initState();
  }

  //Штиклирање на навика
  checkChanged(int index) async {
    setState(() {
      widget.weeklyHabit.days[index] = !widget.weeklyHabit.days[index];
      if (widget.weeklyHabit.days[index]) {
        widget.weeklyHabit.repetitionsDone++;
      } else {
        widget.weeklyHabit.repetitionsDone--;
      }
      widget.checkBoxChanged(widget.weeklyHabit.days[index],
          widget.habit.effortSingle, widget.habit.benefitSingle);
    });
    await DatabaseHelper.instance.updateWeeklyHabit(widget.weeklyHabit);
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
        child: Container(
          width: MediaQuery.of(context).size.width - 120,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 280,
                child: Text(
                  widget.habit.title,
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
                    for (int i = 0; i < widget.weeklyHabit.days.length; i++)
                      InkWell(
                        onTap: () {
                          checkChanged(i);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.weeklyHabit.days[i]
                                  ? Colors.green.shade700
                                  : Colors.transparent,
                              border: Border.all(
                                color: widget.weeklyHabit.days[i]
                                    ? Colors.green.shade700
                                    : Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: widget.weeklyHabit.days[i]
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
                    "${widget.habit.effortSingle.toString()} - ${widget.habit.benefitSingle.toString()}",
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
