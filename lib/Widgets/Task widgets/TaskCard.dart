import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function refreshParent;

  TaskCard({required this.task, required this.refreshParent});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool canDelete = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print('long press');
        setState(() {
          canDelete = !canDelete;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[600],
        ),
        constraints: BoxConstraints(minHeight: 70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.task.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            if (canDelete)
              IconButton(
                onPressed: () async {
                  DatabaseHelper.instance.deleteWeek(widget.task.id!);
                  await widget.refreshParent();
                },
                icon: Icon(Icons.delete),
              ),
          ],
        ),
      ),
    );
  }
}
