import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:flutter/material.dart';

class WeeklyTaskCard extends StatefulWidget {
  final int taskId;
  final int weekId;

  WeeklyTaskCard({required this.taskId, required this.weekId});

  @override
  _WeeklyTaskCardState createState() => _WeeklyTaskCardState();
}

class _WeeklyTaskCardState extends State<WeeklyTaskCard> {
  late Task task;
  late WeeklyTask weeklyTask;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    task = await DatabaseHelper.instance.getTask(widget.taskId);
    weeklyTask = await DatabaseHelper.instance.getWeeklyTask(widget.weekId, widget.taskId);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
        bottom: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[600],
      ),
      constraints: BoxConstraints(minHeight: 70),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width - 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "${task.input.toString()} - ${task.output.toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            weeklyTask.isFinished = !weeklyTask.isFinished;
                            DatabaseHelper.instance.updateWeeklyTask(weeklyTask);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: weeklyTask.isFinished ? Colors.green.shade700 : Colors.transparent,
                              border: Border.all(
                                color: weeklyTask.isFinished ? Colors.green.shade700 : Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: weeklyTask.isFinished
                                ? Icon(
                                    Icons.check,
                                    size: 22.0,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    null,
                                    size: 22.0,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
