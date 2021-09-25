import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/DateService.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Widgets/Habit%20widgets/HabitCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AddButton.dart';
import '../MainMenu.dart';
import 'WeeksPopup.dart';

class WeekDetails extends StatefulWidget {
  Week? week;

  WeekDetails({this.week});

  @override
  _WeekDetailsState createState() => _WeekDetailsState();
}

class _WeekDetailsState extends State<WeekDetails> {
  bool isLoading = true;
  bool shouldShow = false;
  GlobalKey<RefreshIndicatorState> refreshState = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    if (widget.week == null) {
      widget.week = await DatabaseHelper.instance.getCurrentWeek();
    } else if (widget.week!.id == null) {
      widget.week = await DatabaseHelper.instance.getWeekByStartDate(widget.week!.startDate);
    }
    setState(() {
      isLoading = false;
    });
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    if (widget.week?.id != null) {
      widget.week = await DatabaseHelper.instance.getWeek(widget.week!.id!);
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.week == null
                  ? Text('Loading')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.week!.title.split(" ")[0]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateService.formatDate(widget.week!.startDate)),
                            Text(' - '),
                            Text(DateService.formatDate(widget.week!.endDate)),
                          ],
                        ),
                      ],
                    ),
              isLoading
                  ? SizedBox(
                      width: 70,
                    )
                  : IconButton(
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
                              itemCount: widget.week!.habits.length,
                              itemBuilder: (context, index) {
                                final weeklyHabit = widget.week!.habits[index];
                                return Container(
                                  margin: index == widget.week!.habits.length - 1 ? EdgeInsets.only(bottom: 50) : EdgeInsets.only(bottom: 0),
                                  child: HabitCard(
                                    habitId: weeklyHabit.habitFK,
                                    refreshParent: refresh,
                                  ),
                                );
                              }),
                        ),
                      ),
              ]),
            ),
            if (widget.week != null)
              Positioned(
                right: 0,
                top: 0,
                child: WeeksPopup(
                  show: shouldShow,
                  selectedWeek: widget.week!,
                ),
              ),
            AddButton(
              refreshParent: refresh,
              text: "Add Habit",
              position: Position.bottomLeft,
              type: AddButtonType.addHabit,
            ),
            AddButton(
              refreshParent: refresh,
              text: "Add Task",
              position: Position.bottomRight,
              type: AddButtonType.addTask,
            ),
          ],
        ),
      ),
    );
  }
}
