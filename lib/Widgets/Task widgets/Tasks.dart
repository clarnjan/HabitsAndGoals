import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:flutter/material.dart';

import '../MainMenu.dart';
import '../AddButton.dart';
import 'TaskCard.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  late List<Task> tasks;
  bool isLoading = true;
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
    this.tasks = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: MainMenu(),
      ),
      appBar: AppBar(
        title: Text('Tasks'),
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
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Container(
                          margin: index == tasks.length - 1
                              ? EdgeInsets.only(bottom: 50)
                              : EdgeInsets.only(bottom: 0),
                          child: TaskCard(task: task,refreshParent: refresh,),
                        );
                      }),
                ),
              ),
            ]),
          ),
          AddButton(refreshParent: refresh, text: "Add Task",position: Position.bottomRight, type: AddButtonType.addTask,),
        ],
      ),
    );
  }
}
