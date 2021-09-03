import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NewTaskDialog.dart';

class NewTaskButton extends StatelessWidget {
  final Function refreshParent;
  const NewTaskButton({Key? key, required this.refreshParent}) : super(key: key);

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
      right: 10,
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
                "New task",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
