import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/DateService.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Widgets/WeeklyHabitCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../FloatingButton.dart';
import '../MainMenu.dart';
import 'WeeksPopup.dart';

class WeekDetails extends StatefulWidget {
  final Week? initialWeek;

  WeekDetails({this.initialWeek});

  @override
  _WeekDetailsState createState() => _WeekDetailsState();
}

class _WeekDetailsState extends State<WeekDetails> {
  late Week week;
  bool isLoading = true;
  bool shouldShow = false;
  GlobalKey<RefreshIndicatorState> refreshState =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    if (widget.initialWeek == null) {
      week = await DatabaseHelper.instance.getCurrentWeek();
    } else if (widget.initialWeek!.id == null) {
      week = await DatabaseHelper.instance
          .getWeekByStartDate(widget.initialWeek!.startDate);
    }
    setState(() {
      isLoading = false;
    });
  }

  refresh() async {
    if (week.id != null) {
      week = await DatabaseHelper.instance.getWeek(week.id!);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          shouldShow = false;
        });
      },
      child: Scaffold(
        drawer: Drawer(
          child: MainMenu(),
        ),
        appBar: AppBar(
          title: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text('Loading'),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(week.title.split(" ")[0]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(DateService.formatDate(week.startDate)),
                              Text(' - '),
                              Text(DateService.formatDate(week.endDate)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_drop_down_outlined),
                      onPressed: () {
                        setState(() {
                          shouldShow = !shouldShow;
                        });
                      },
                    ),
                  ],
                ),
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.grey[800],
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Flex(direction: Axis.vertical, children: [
                isLoading
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          key: refreshState,
                          onRefresh: () async {
                            await refresh();
                          },
                          child: ListView.builder(
                              itemCount: week.habits.length,
                              itemBuilder: (context, index) {
                                final weeklyHabit = week.habits[index];
                                return Container(
                                  margin: index == week.habits.length - 1
                                      ? EdgeInsets.only(bottom: 50)
                                      : EdgeInsets.only(bottom: 0),
                                  child: WeeklyHabitCard(
                                    weekId: week.id!,
                                    habitId: weeklyHabit.habitFK,
                                  ),
                                );
                              }),
                        ),
                      ),
              ]),
            ),
            if (!isLoading)
              Positioned(
                right: 0,
                top: 0,
                child: WeeksPopup(
                  show: shouldShow,
                  selectedWeek: week,
                ),
              ),
            if (!isLoading)
              FloatingButton(
                refreshParent: refresh,
                position: Position.bottomLeft,
                type: FloatingButtonType.selectHabits,
                week: week,
              ),
            FloatingButton(
              refreshParent: refresh,
              position: Position.bottomRight,
              type: FloatingButtonType.addTask,
            ),
          ],
        ),
      ),
    );
  }
}
