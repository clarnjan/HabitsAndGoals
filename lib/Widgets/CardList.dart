import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Goal widgets/AddGoalDialog.dart';
import 'Goal widgets/GoalCard.dart';
import 'Habit widgets/AddHabitDialog.dart';
import 'Habit widgets/HabitCard.dart';
import 'Habit widgets/HabitDetails.dart';
import 'MainMenu.dart';
import 'Task widgets/AddTaskDialog.dart';
import 'Task widgets/TaskCard.dart';

class CardList extends StatefulWidget {
  final CardListType cardListType;

  const CardList({Key? key, required this.cardListType}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  late List items;
  bool isLoading = true;
  String appBarTitle = "Loading";
  late FloatingButtonType floatingButtonType;
  GlobalKey<RefreshIndicatorState> refreshState = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    switch (widget.cardListType) {
      case CardListType.Habits:
        {
          this.items = await DatabaseHelper.instance.getAllHabits();
          appBarTitle = "Habits";
          floatingButtonType = FloatingButtonType.AddHabit;
          break;
        }
      case CardListType.Tasks:
        {
          this.items = await DatabaseHelper.instance.getAllTasks();
          appBarTitle = "Tasks";
          floatingButtonType = FloatingButtonType.AddTask;
          break;
        }
      case CardListType.Goals:
        {
          this.items = await DatabaseHelper.instance.getAllGoals();
          appBarTitle = "Goals";
          floatingButtonType = FloatingButtonType.AddGoal;
          break;
        }
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget getCard(item) {
    switch (widget.cardListType) {
      case CardListType.Habits:
        return HabitCard(
          habitId: item.id!,
          refreshParent: refresh,
          tapFunction: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HabitDetails(item)));
          },
        );
      case CardListType.Tasks:
        return TaskCard(
          task: item,
          refreshParent: refresh,
        );
      case CardListType.Goals:
        return GoalCard(goal: item, refreshParent: refresh);
    }
  }

  Future<void> floatingButtonClick(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        switch (widget.cardListType) {
          case CardListType.Habits:
            return AddHabitDialog(refreshParent: refresh);
          case CardListType.Tasks:
            return AddTaskDialog(refreshParent: refresh);
          case CardListType.Goals:
            return AddGoalDialog(refreshParent: refresh);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: MainMenu(),
      ),
      appBar: AppBar(
        title: Text(appBarTitle),
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
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Container(
                                margin: index == items.length - 1 ? EdgeInsets.only(bottom: 50) : EdgeInsets.only(bottom: 0),
                                child: getCard(item),
                              );
                            }),
                      ),
                    ),
            ]),
          ),
          if (!isLoading)
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  await floatingButtonClick(context);
                },
                backgroundColor: Colors.green.shade700,
                child: Icon(Icons.add),
              ),
            ),
        ],
      ),
    );
  }
}
