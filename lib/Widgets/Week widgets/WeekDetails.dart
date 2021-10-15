import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/DateService.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Widgets/LabelWidget.dart';
import 'package:diplomska1/Widgets/WeeklyHabitCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Dialogs/CustomDialog.dart';
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
  final Key centerKey = ValueKey('second-sliver-list');
  final ScrollController scrollController = ScrollController();
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
    if (widget.initialWeek == null) {
      week = await DatabaseHelper.instance.getCurrentWeek();
    } else if (widget.initialWeek!.id == null) {
      week = await DatabaseHelper.instance.getWeekByStartDate(widget.initialWeek!.startDate);
    }
    setState(() {
      isLoading = false;
    });
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    if (week.id != null) {
      week = await DatabaseHelper.instance.getWeek(week.id!);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
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
              color: Colors.grey.shade800,
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
                          child: CustomScrollView(
                            controller: scrollController,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Container(
                                      child: WeeklyHabitCard(
                                        weekId: week.id!,
                                        habitId: week.habits[index].habitFK,
                                      ),
                                    );
                                  },
                                  childCount: week.habits.length,
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Container(
                                      child: WeeklyHabitCard(
                                        weekId: week.id!,
                                        habitId: week.habits[index].habitFK,
                                      ),
                                    );
                                  },
                                  childCount: week.habits.length,
                                ),
                              ),
                            ],
                          ),
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
              Positioned(
                right: 20,
                bottom: 20,
                child: SpeedDial(
                  animatedIcon: AnimatedIcons.add_event,
                  animatedIconTheme: IconThemeData(size: 22.0),
                  // this is ignored if animatedIcon is non null
                  // child: Icon(Icons.add),
                  visible: true,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.grey.shade800,
                  elevation: 1.0,
                  buttonSize: 67,
                  childrenButtonSize: 60,
                  spaceBetweenChildren: 10,
                  shape: CircleBorder(),
                  children: [
                    SpeedDialChild(
                      child: Icon(Icons.checklist_rtl),
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.grey.shade800,
                      labelWidget: LabelWidget(
                        text: "Habit",
                        backgroundColor: Colors.blue.shade600,
                        color: Colors.grey.shade800,
                      ),
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                weekId: week.id!,
                                canSelect: true,
                                refreshParent: refresh,
                                noteType: NoteType.Habit,
                              );
                            });
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.task),
                      backgroundColor: Colors.amber.shade800,
                      foregroundColor: Colors.grey.shade800,
                      labelWidget: LabelWidget(
                        text: "Task",
                        backgroundColor: Colors.amber.shade800,
                        color: Colors.grey.shade800,
                      ),
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                weekId: week.id!,
                                canSelect: true,
                                refreshParent: refresh,
                                noteType: NoteType.Task,
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
