import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Widgets/TaskCard.dart';
import 'package:flutter/material.dart';
import 'MainMenu.dart';
import 'NewTaskButton.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Task> tasks;
  bool isLoading = true;

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
      body: SafeArea(
        child: Stack(
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
                        child: ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Container(
                                margin: index == tasks.length - 1
                                    ? EdgeInsets.only(bottom: 50)
                                    : EdgeInsets.only(bottom: 0),
                                child: TaskCard(task: task),
                              );
                            }),
                      ),
              ]),
            ),
            NewTaskButton(refreshParent: refresh),

          ],
        ),
      ),
    );
  }
}
