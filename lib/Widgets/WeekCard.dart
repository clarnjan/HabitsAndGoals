import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:flutter/material.dart';

import 'WeekDetails.dart';

class WeekCard extends StatefulWidget {
  Week week;

  WeekCard({required this.week});

  @override
  _WeekCardState createState() => _WeekCardState();
}

class _WeekCardState extends State<WeekCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WeekDetails(widget.week)));
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.week.title,
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
      ),
    );
  }
}
