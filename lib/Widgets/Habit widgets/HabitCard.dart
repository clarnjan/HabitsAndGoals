import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Widgets/Habit%20widgets/HabitDetails.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final Function refreshParent;

  HabitCard({required this.habit, required this.refreshParent});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool canDelete = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HabitDetails(widget.habit)));
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
        constraints: BoxConstraints(
            minHeight: 70
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.habit.title,
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
                  DatabaseHelper.instance.deleteWeek(widget.habit.id!);
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
