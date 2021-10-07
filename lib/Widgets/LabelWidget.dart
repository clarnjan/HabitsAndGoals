import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final String text;
  final Color color;
  const LabelWidget({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 50,
      height: 30,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
