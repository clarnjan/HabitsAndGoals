import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Widgets/Dialogs/EditDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ClickableCard.dart';
import 'Dialogs/AddOrSelectDialog.dart';
import 'EmptyState.dart';
import 'Goal widgets/GoalDetails.dart';
import 'MainMenu.dart';
import 'Task widgets/TaskList.dart';

class CardList extends StatefulWidget {
  final NoteType noteType;

  const CardList({Key? key, required this.noteType}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  List items = [];
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
        break;
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
            cardTapFunction(item.id!);
          },
        );
      case NoteType.Task:
        return ClickableCard(
          title: item.title,
          isSelectable: false,
          tapFunction: () {
            cardTapFunction(item.id!);
          },
        );
      case NoteType.Goal:
        return ClickableCard(
          title: item.title,
          isSelectable: false,
          tapFunction: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalDetails(
                          goalId: item.id,
                          refreshParent: refresh,
                        )));
          },
        );
    }
  }

  Future<void> cardTapFunction(int id) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          afterDelete: refresh,
          refreshParent: refresh,
          noteType: widget.noteType,
          itemId: id,
        );
      },
    );
  }

  Future<void> floatingButtonClick(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AddOrSelectDialog(
          canSelect: false,
          refreshParent: refresh,
          noteType: widget.noteType,
        );
      },
    );
  }

  String getEmptyStateText() {
    switch (widget.noteType) {
      case NoteType.Habit:
        return "No habits added.\nClick the button below to add some";
      case NoteType.Task:
        return "No tasks added.\nClick the button below to add some";
      case NoteType.Goal:
        return "No goals added.\nClick the button below to add some";
    }
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
            padding: EdgeInsets.all(5),
            child: Flex(direction: Axis.vertical, children: [
              Expanded(
                child: widget.noteType == NoteType.Task
                    ? TaskList()
                    : RefreshIndicator(
                        key: refreshState,
                        onRefresh: () async {
                          await refresh();
                        },
                        child: items.length > 0
                            ? ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return Container(
                                    margin: index == items.length - 1 ? EdgeInsets.only(bottom: 50) : EdgeInsets.only(bottom: 0),
                                    child: getCard(item),
                                  );
                                })
                            : ListView(
                                children: [
                                  EmptyState(
                                    text: getEmptyStateText(),
                                  ),
                                ],
                              ),
                      ),
              ),
            ]),
          ),
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
