import 'package:diplomska1/Classes/Enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NewTaskDialog.dart';

class AddButton extends StatelessWidget {
  final Function refreshParent;
  final String text;
  final Position? position;
  final Color? color;
  const AddButton({Key? key, required this.refreshParent, required this.text, this.position, this.color }) : super(key: key);

  Future<void> showNewTaskDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return NewTaskDialog(refreshParent: refreshParent);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: position == Position.bottomRight? 10 : null,
      left: position == Position.bottomLeft? 10 : null,
      child: GestureDetector(
        onTap: () async {
          await showNewTaskDialog(context);
        },
        child: Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: color ?? Colors.green[700],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
