import 'package:diplomska1/Classes/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ClickableCard.dart';

class SelectTasksDialog extends StatefulWidget {
  final List<Task> tasks;
  final Function selectTask;

  const SelectTasksDialog({Key? key, required this.selectTask, required this.tasks}) : super(key: key);

  @override
  _SelectTasksDialogState createState() => _SelectTasksDialogState();
}

class _SelectTasksDialogState extends State<SelectTasksDialog> {
  @override
  Widget build(BuildContext context) {
    return widget.tasks.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: widget.tasks.length,
            itemBuilder: (context, index) {
              final task = widget.tasks[index];
              return Container(
                child: ClickableCard(
                  isSelectable: true,
                  title: task.title,
                  tapFunction: () {
                    widget.selectTask(task);
                  },
                ),
              );
            })
        : Container(
            height: 200,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "No available tasks.\nClick \"New\" to add more",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
