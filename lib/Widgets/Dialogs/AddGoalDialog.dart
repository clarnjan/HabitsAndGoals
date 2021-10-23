import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:flutter/material.dart';

import 'AddOrSelectDialog.dart';

class AddGoalDialog extends StatefulWidget {
  final int? weekId;
  final int? goalId;
  final Function refreshParent;
  final AddEditItemController controller;

  const AddGoalDialog({Key? key, this.weekId, required this.refreshParent, required this.controller, this.goalId}) : super(key: key);

  @override
  _AddGoalDialogState createState() => _AddGoalDialogState(controller);
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  late Goal goal;
  bool isLoading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  _AddGoalDialogState(AddEditItemController _controller) {
    _controller.onSave = onSave;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    if (widget.goalId != null) {
      goal = await DatabaseHelper.instance.getGoal(widget.goalId!);
    } else {
      goal = new Goal();
    }
    setState(() {
      isLoading = false;
    });
  }

  onSave() async {
    if (formKey.currentState!.validate()) {
      goal.createdTime = DateTime.now();
      if (goal.id != null) {
        await DatabaseHelper.instance.updateGoal(goal);
      } else {
        goal = await DatabaseHelper.instance.createGoal(goal);
      }
      await widget.refreshParent();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autofocus: true,
                  validator: (value) {
                    setState(() {
                      goal.title = value!;
                    });
                    return value!.isNotEmpty ? null : "Title is mandatory";
                  },
                  initialValue: goal.title,
                  keyboardType: TextInputType.visiblePassword,
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
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      goal.description = value;
                    });
                  },
                  initialValue: goal.description,
                  keyboardType: TextInputType.visiblePassword,
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
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
