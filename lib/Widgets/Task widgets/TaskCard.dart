import 'package:diplomska1/Classes/Task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final Task task;

  TaskCard({required this.task});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
        bottom: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[600],
      ),
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
          Container(
            margin: EdgeInsets.only(
                right: 10
            ),
            // child: Text(
            //   widget.task.input.toString() +
            //       ' - ' +
            //       widget.task.output.toString(),
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 20,
            //     color: Colors.white,
            //   ),
            // ),
          ),
          Transform.scale(
            scale: 1.5,
            // child: Checkbox(
            //   checkColor: Colors.white,
            //   value: widget.task.finished,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            //   onChanged: (bool? value) {
            //     setState(() {
            //       widget.task.finished = value!;
            //     });
            //   },
            // ),
          )
        ],
      ),
    );
  }
}
