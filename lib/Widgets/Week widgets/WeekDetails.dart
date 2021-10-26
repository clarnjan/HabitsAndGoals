import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/DateService.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Classes/WeeklyHabit.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:diplomska1/Widgets/Dialogs/EditDialog.dart';
import 'package:diplomska1/Widgets/Habit%20widgets/HabitCard.dart';
import 'package:diplomska1/Widgets/LabelWidget.dart';
import 'package:diplomska1/Widgets/Task%20widgets/TaskCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Dialogs/AddOrSelectDialog.dart';
import '../EmptyState.dart';
import '../MainMenu.dart';
import 'WeeksPopup.dart';

class WeekDetails extends StatefulWidget {
  final Week? initialWeek;

  WeekDetails({this.initialWeek});

  @override
  _WeekDetailsState createState() => _WeekDetailsState();
}

class _WeekDetailsState extends State<WeekDetails> {
  Week? week;
  bool isLoading = true;
  bool shouldShow = false;
  int habitsEffort = 0;
  int tasksEffort = 0;
  int habitsBenefit = 0;
  int tasksBenefit = 0;
  List<Habit> habits = [];
  List<Task> tasks = [];
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
    await updateHabitsAndTasks();
    await updateHabitsEffortAndBenefit();
    await updateTasksEffortAndBenefit();
    setState(() {
      isLoading = false;
    });
  }

  updateHabitsAndTasks() async {
    habits = [];
    tasks = [];
    for (WeeklyHabit wh in week!.habits) {
      habits.add(await DatabaseHelper.instance.getHabit(wh.habitFK));
    }
    for (WeeklyTask wt in week!.tasks) {
      tasks.add(await DatabaseHelper.instance.getTask(wt.taskFK));
    }
  }

  updateHabitsEffortAndBenefit() async {
    habitsEffort = 0;
    habitsBenefit = 0;
    for (WeeklyHabit wh in week!.habits) {
      Habit habit = await DatabaseHelper.instance.getHabit(wh.habitFK);
      habitsEffort += wh.repetitionsDone * habit.effortSingle;
      habitsBenefit += wh.repetitionsDone * habit.benefitSingle;
    }
  }

  updateTasksEffortAndBenefit() async {
    tasksEffort = 0;
    tasksBenefit = 0;
    for (WeeklyTask wt in week!.tasks) {
      if (wt.isFinished) {
        Task task = await DatabaseHelper.instance.getTask(wt.taskFK);
        tasksEffort += task.effort;
        tasksBenefit += task.benefit;
      }
    }
  }

  habitCheckChanged(bool isFinished, int effort, int benefit) {
    setState(() {
      if (isFinished) {
        habitsEffort += effort;
        habitsBenefit += benefit;
      } else {
        habitsEffort -= effort;
        habitsBenefit -= benefit;
      }
    });
  }

  taskCheckChanged(bool isFinished, int effort, int benefit) {
    setState(() {
      if (isFinished) {
        tasksEffort += effort;
        tasksBenefit += benefit;
      } else {
        tasksEffort -= effort;
        tasksBenefit -= benefit;
      }
    });
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    if (week!.id != null) {
      week = await DatabaseHelper.instance.getWeek(week!.id!);
    }
    await updateHabitsAndTasks();
    await updateHabitsEffortAndBenefit();
    await updateTasksEffortAndBenefit();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> cardTapFunction(int id, NoteType noteType) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          afterDelete: refresh,
          refreshParent: refresh,
          noteType: noteType,
          itemId: id,
        );
      },
    );
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
            title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(week != null ? week!.title.split(" ")[0] : 'Loading...'),
                  if (week != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateService.formatDate(week!.startDate)),
                        Text(' - '),
                        Text(DateService.formatDate(week!.endDate)),
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
        )),
        body: Stack(
          children: [
            Container(
              color: Colors.grey.shade800,
              width: double.infinity,
              padding: EdgeInsets.all(5),
              child: Flex(direction: Axis.vertical, children: [
                week == null
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
                          child: week!.habits.length > 0 || week!.tasks.length > 0
                              ? CustomScrollView(
                                  controller: scrollController,
                                  physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                  shrinkWrap: true,
                                  slivers: <Widget>[
                                    if (week!.habits.length > 0 || week!.tasks.length > 0)
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                        return Container(
                                          padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                          child: Wrap(
                                            alignment: WrapAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total effort and benefit:",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "${habitsEffort + tasksEffort} - ${habitsBenefit + tasksBenefit}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }, childCount: 1)),
                                    if (week!.habits.length > 0)
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Habits:",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Text(
                                                "$habitsEffort - $habitsBenefit",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }, childCount: 1)),
                                    if (habits.length > 0)
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                bottom: week!.tasks.isNotEmpty || index < week!.habits.length - 1 ? 0 : 70,
                                              ),
                                              child: HabitCard(
                                                habit: habits.firstWhere((element) => element.id == week!.habits[index].habitFK),
                                                weeklyHabit: week!.habits[index],
                                                tapFunction: () {
                                                  cardTapFunction(week!.habits[index].habitFK, NoteType.Habit);
                                                },
                                                checkBoxChanged: habitCheckChanged,
                                              ),
                                            );
                                          },
                                          childCount: week!.habits.length,
                                        ),
                                      ),
                                    if (week!.tasks.length > 0)
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Tasks:",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Text(
                                                "$tasksEffort - $tasksBenefit",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }, childCount: 1)),
                                    if (tasks.length > 0)
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                bottom: index < week!.tasks.length - 1 ? 0 : 70,
                                              ),
                                              child: TaskCard(
                                                weeklyTask: week!.tasks[index],
                                                task: tasks.firstWhere((element) => element.id == week!.tasks[index].taskFK),
                                                tapFunction: () {
                                                  cardTapFunction(week!.tasks[index].taskFK, NoteType.Task);
                                                },
                                                checkBoxChanged: taskCheckChanged,
                                              ),
                                            );
                                          },
                                          childCount: week!.tasks.length,
                                        ),
                                      ),
                                  ],
                                )
                              : ListView(
                                  children: [
                                    EmptyState(text: "No habits or tasks added for this week.\nClick the button below to add some"),
                                  ],
                                ),
                        ),
                      ),
              ]),
            ),
            if (week != null)
              Positioned(
                right: 0,
                top: 0,
                child: WeeksPopup(
                  show: shouldShow,
                  selectedWeek: week!,
                ),
              ),
            if (week != null)
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
                              return AddOrSelectDialog(
                                weekId: week!.id!,
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
                              return AddOrSelectDialog(
                                weekId: week!.id!,
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
