import 'package:diplomska1/Classes/Week.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekDetails extends StatefulWidget {
  final Week week;
  const WeekDetails(this.week, {Key? key}) : super(key: key);

  @override
  _WeekDetailsState createState() => _WeekDetailsState();
}

class _WeekDetailsState extends State<WeekDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(widget.week.title),
            Text('${widget.week.startDate.day}/${widget.week.startDate.month}/${widget.week.startDate.year}'),
            Text('${widget.week.endDate.day}/${widget.week.endDate.month}/${widget.week.endDate.year}'),
          ],
        ),
      ),
    );
  }
}
