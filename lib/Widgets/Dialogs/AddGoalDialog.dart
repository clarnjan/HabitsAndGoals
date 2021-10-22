import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:flutter/material.dart';

import 'CustomDialog.dart';

class AddGoalDialog extends StatefulWidget {
  final int? weekId;
  final Function refreshParent;
  final AddItemController controller;

  const AddGoalDialog({Key? key, this.weekId, required this.refreshParent, required this.controller}) : super(key: key);

  @override
  _AddGoalDialogState createState() => _AddGoalDialogState(controller);
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  String? title;
  String? description;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  _AddGoalDialogState(AddItemController _controller) {
    _controller.onSave = onSave;
  }

  onSave() async {
    if (formKey.currentState!.validate()) {
      Goal goal = Goal(
        title: title!,
        description: description,
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
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          TextFormField(
            autofocus: true,
            controller: textEditingController,
            validator: (value) {
              setState(() {
                title = value!;
              });
              return value!.isNotEmpty ? null : "Title is mandatory";
            },
            decoration: InputDecoration(
              hintText: "Title",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                description = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Description",
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
