import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Помошен виџет за лабела
class LabelWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color color;
  const LabelWidget(
      {Key? key,
      required this.text,
      required this.backgroundColor,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 50,
      height: 30,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 15, color: color),
        ),
      ),
    );
  }
}
