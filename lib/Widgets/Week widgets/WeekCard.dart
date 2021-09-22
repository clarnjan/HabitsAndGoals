import 'package:diplomska1/Classes/DateFormatService.dart';
import 'package:diplomska1/Classes/Week.dart';
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => WeekDetails(widget.week.id!)));
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
            "${DateFormatService.formatDate(widget.week.startDate)} - ${DateFormatService.formatDate(widget.week.endDate)}",
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
