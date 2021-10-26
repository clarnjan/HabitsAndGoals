import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Widgets/ClickableCard.dart';
import 'package:diplomska1/Widgets/Dialogs/AddOrSelectDialog.dart';
import 'package:diplomska1/Widgets/Dialogs/EditDialog.dart';
import 'package:diplomska1/Widgets/Task%20widgets/TaskCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../EmptyState.dart';
import '../MainMenu.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> oneTimeTasks = [];
  List<Task> repeatingTasks = [];
  bool isLoading = true;
  final Key centerKey = ValueKey('second-sliver-list');
  final ScrollController scrollController = ScrollController();
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
    final tasks = await DatabaseHelper.instance.getAllTasks();
    oneTimeTasks = tasks.where((element) => !element.isRepeating).toList();
    repeatingTasks = tasks.where((element) => element.isRepeating).toList();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> cardTapFunction(int id) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          afterDelete: refresh,
          refreshParent: refresh,
          noteType: NoteType.Task,
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
          noteType: NoteType.Task,
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
        title: Text("Tasks"),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[800],
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(5),
            child: RefreshIndicator(
              key: refreshState,
              onRefresh: () async {
                await refresh();
              },
              child: oneTimeTasks.length > 0 || repeatingTasks.length > 0
                  ? CustomScrollView(
                      controller: scrollController,
                      physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      shrinkWrap: true,
                      slivers: <Widget>[
                        if (oneTimeTasks.length > 0)
                          SliverList(
                              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              child: Text(
                                "One time tasks:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                            );
                          }, childCount: 1)),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: oneTimeTasks.isNotEmpty || index < oneTimeTasks.length - 1 ? 0 : 70,
                                ),
                                child: TaskCard(
                                  task: oneTimeTasks[index],
                                  tapFunction: () {
                                    cardTapFunction(oneTimeTasks[index].id!);
                                  },
                                ),
                              );
                            },
                            childCount: oneTimeTasks.length,
                          ),
                        ),
                        if (repeatingTasks.length > 0)
                          SliverList(
                              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              child: Text(
                                "Repeating tasks:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                            );
                          }, childCount: 1)),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: index < repeatingTasks.length - 1 ? 0 : 70,
                                ),
                                child: ClickableCard(
                                  title: repeatingTasks[index].title,
                                  isSelectable: false,
                                  effortAndBenefit: "${repeatingTasks[index].effort} - ${repeatingTasks[index].benefit}",
                                  tapFunction: () {
                                    cardTapFunction(repeatingTasks[index].id!);
                                  },
                                ),
                              );
                            },
                            childCount: repeatingTasks.length,
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        EmptyState(text: "No tasks added.\nClick the button below to add some"),
                      ],
                    ),
            ),
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
