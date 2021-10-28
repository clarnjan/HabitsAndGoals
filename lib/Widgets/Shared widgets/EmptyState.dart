import 'package:flutter/material.dart';

//Порака кога не постојат ставки во лситата
class EmptyState extends StatelessWidget {
  final String text;
  const EmptyState({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
