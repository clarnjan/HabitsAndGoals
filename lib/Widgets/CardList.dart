import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ClickableCard.dart';
import 'Dialogs/CustomDialog.dart';
import 'Goal widgets/GoalDetails.dart';
import 'Habit widgets/HabitDetails.dart';
import 'MainMenu.dart';
import 'Task widgets/TaskDetails.dart';

class CardList extends StatefulWidget {
  final NoteType noteType;

  const CardList({Key? key, required this.noteType}) : super(key: key);

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
    switch (widget.noteType) {
      case NoteType.Habit:
        {
          this.items = await DatabaseHelper.instance.getAllHabits();
          appBarTitle = "Habits";
          floatingButtonType = FloatingButtonType.AddHabit;
          break;
        }
      case NoteType.Task:
        {
          this.items = await DatabaseHelper.instance.getAllTasks();
          appBarTitle = "Tasks";
          floatingButtonType = FloatingButtonType.AddTask;
          break;
        }
      case NoteType.Goal:
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
    switch (widget.noteType) {
      case NoteType.Habit:
        return ClickableCard(
          title: item.title,
          isSelectable: false,
          tapFunction: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HabitDetails(item.id)));
          },
        );
      case NoteType.Task:
        return ClickableCard(
          title: item.title,
          isSelectable: false,
          tapFunction: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetails(item.id)));
          },
        );
      case NoteType.Goal:
        return ClickableCard(
          title: item.title,
          isSelectable: false,
          tapFunction: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => GoalDetails(item.id)));
          },
        );
    }
  }

  Future<void> floatingButtonClick(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          canSelect: false,
          refreshParent: refresh,
          noteType: widget.noteType,
        );
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
              child: Container(
                width: 67,
                height: 67,
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: () async {
                      await floatingButtonClick(context);
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.grey.shade800,
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
