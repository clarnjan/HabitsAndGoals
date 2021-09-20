import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/DateFormatService.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Widgets/Habit%20widgets/HabitCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AddButton.dart';
import '../CostumPopup.dart';
import '../MainMenu.dart';

class WeekDetails extends StatefulWidget {
  final int weekId;

  const WeekDetails(this.weekId, {Key? key}) : super(key: key);

  @override
  _WeekDetailsState createState() => _WeekDetailsState();
}

class _WeekDetailsState extends State<WeekDetails> {
  Week? week;
  List<String> weeks = [];
  bool isLoading = true;
  bool shouldShow = false;
  GlobalKey<RefreshIndicatorState> refreshState =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    weeks.add("A");
    this.week = await DatabaseHelper.instance.getWeek(widget.weekId);
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
              week == null
                  ? Text('loading')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(week!.title.split(" ")[0]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormatService.formatDate(week!.startDate)),
                            Text(' - '),
                            Text(DateFormatService.formatDate(week!.endDate)),
                          ],
                        ),
                      ],
                    ),
              isLoading
                  ? SizedBox()
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
                              itemCount: week!.habits.length,
                              itemBuilder: (context, index) {
                                final weeklyHabit = week!.habits[index];
                                return Container(
                                  margin: index == week!.habits.length - 1
                                      ? EdgeInsets.only(bottom: 50)
                                      : EdgeInsets.only(bottom: 0),
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
            Positioned(
              right: 0,
              top: 0,
              child: CustomPopup(
                show: shouldShow,
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
