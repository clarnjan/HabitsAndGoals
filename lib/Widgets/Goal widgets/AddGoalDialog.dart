import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:flutter/material.dart';

import '../DialogButtons.dart';

class AddGoalDialog extends StatefulWidget {
  final Goal? goal;
  final Function refreshParent;

  const AddGoalDialog({Key? key, this.goal, required this.refreshParent}) : super(key: key);

  @override
  _AddGoalDialogState createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  String title = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  addGoal() async {
    if (formKey.currentState!.validate()) {
      final goal = Goal(
        title: title,
        createdTime: DateTime.now(),
        isFinished: false,
      );

      DatabaseHelper.instance.createGoal(goal);
      await widget.refreshParent();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textEditingController,
              validator: (value) {
                setState(() {
                  title = value!;
                });
                return value!.isNotEmpty ? null : "Title is mandatory";
              },
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
          ],
        ),
      ),
      actions: [
        DialogButtons(
          cancelText: "Cancel",
          submitText: "Save",
          showAddButton: false,
          refreshParent: widget.refreshParent,
          submitFunction: addGoal,
        ),
      ],
    );
  }
}
