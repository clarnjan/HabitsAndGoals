import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../MainMenu.dart';

class TaskDetails extends StatefulWidget {
  final int taskId;

  const TaskDetails(this.taskId, {Key? key}) : super(key: key);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late Task task;
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
    this.task = await DatabaseHelper.instance.getTask(widget.taskId);
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
        title: isLoading ? Text('loading') : Text(task.title),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[800],
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
