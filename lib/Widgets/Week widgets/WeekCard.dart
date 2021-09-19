import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:flutter/material.dart';
import 'WeekDetails.dart';

class WeekCard extends StatefulWidget {
  final Week week;
  final Function refreshParent;

  WeekCard({required this.week, required this.refreshParent});

  @override
  _WeekCardState createState() => _WeekCardState();
}

class _WeekCardState extends State<WeekCard> {
  bool canDelete = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WeekDetails(widget.week.id!)));
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
                widget.week.title,
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
                  DatabaseHelper.instance.deleteWeek(widget.week.id!);
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
