import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:diplomska1/Widgets/Goal%20widgets/GoalDetails.dart';
import 'package:flutter/material.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;
  final Function refreshParent;

  GoalCard({required this.goal, required this.refreshParent});

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool canDelete = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoalDetails(widget.goal.id!)));
      },
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
                widget.goal.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '${widget.goal.isFinished}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            if (canDelete)
              IconButton(
                onPressed: () async {
                  DatabaseHelper.instance.deleteWeek(widget.goal.id!);
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
