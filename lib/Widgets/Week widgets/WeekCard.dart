import 'package:diplomska1/Classes/DateService.dart';
import 'package:diplomska1/Classes/Tables/Week.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'WeekDetails.dart';

class WeekCard extends StatefulWidget {
  final Week week;
  final bool isCurrent;

  WeekCard({required this.week, required this.isCurrent});

  @override
  _WeekCardState createState() => _WeekCardState();
}

class _WeekCardState extends State<WeekCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WeekDetails(initialWeek: widget.week)));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          bottom: 1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[600],
        ),
        child: Center(
          child: Text(
            "${DateService.formatDate(widget.week.startDate)} - ${DateService.formatDate(widget.week.endDate)}",
            style: TextStyle(
              color: widget.isCurrent ? Colors.green : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
