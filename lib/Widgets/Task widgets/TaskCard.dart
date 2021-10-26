import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/WeeklyTask.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final WeeklyTask? weeklyTask;
  final Function tapFunction;
  final Function? checkBoxChanged;

  TaskCard({required this.task, required this.tapFunction, this.weeklyTask, this.checkBoxChanged});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    super.initState();
  }

  bool isFinished() {
    if (!widget.task.isRepeating) {
      return widget.task.isFinished;
    }
    if (widget.weeklyTask != null) {
      return widget.weeklyTask!.isFinished;
    }
    return false;
  }

  checkChanged() async {
    setState(() {
      if (!widget.task.isRepeating) {
        widget.task.isFinished = !widget.task.isFinished;
      }
      if (widget.weeklyTask != null) {
        widget.weeklyTask!.isFinished = !widget.weeklyTask!.isFinished;
        if (widget.checkBoxChanged != null) {
          widget.checkBoxChanged!(widget.weeklyTask!.isFinished, widget.task.effort, widget.task.benefit);
        }
      } else if (widget.checkBoxChanged != null) {
        widget.checkBoxChanged!(widget.task.isFinished, widget.task.effort, widget.task.benefit);
      }
    });
    if (!widget.task.isRepeating) {
      await DatabaseHelper.instance.updateTask(widget.task);
    }
    if (widget.weeklyTask != null) {
      await DatabaseHelper.instance.updateWeeklyTask(widget.weeklyTask!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.tapFunction();
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[600],
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 120,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 105,
                child: Row(
                  children: [
                    if (widget.weeklyTask == null)
                      Text(
                        'Title: ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                        ),
                      ),
                    Text(
                      widget.task.title,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: checkChanged,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isFinished() ? Colors.green.shade700 : Colors.transparent,
                      border: Border.all(
                        color: isFinished() ? Colors.green.shade700 : Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isFinished()
                        ? Icon(
                            Icons.check,
                            size: 18.0,
                            color: Colors.white,
                          )
                        : Icon(
                            null,
                            size: 18.0,
                          ),
                  ),
                ),
              ),
              Container(
                width: 50,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${widget.task.effort.toString()} - ${widget.task.benefit.toString()}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
