import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:flutter/material.dart';

import '../DialogButtons.dart';

class DeleteDialog extends StatefulWidget {
  final int goalId;
  final String title;
  final Function refreshParent;
  final Function afterDelete;
  const DeleteDialog({Key? key, required this.title, required this.refreshParent, required this.goalId, required this.afterDelete})
      : super(key: key);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  delete() async {
    await DatabaseHelper.instance.deleteGoal(widget.goalId);
    Navigator.pop(context);
    await widget.afterDelete();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Delete",
        style: TextStyle(color: Colors.white),
      ),
      titlePadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      backgroundColor: Colors.grey[800],
      content: Container(
        child: Text(
          "Are you sure you want to delete \"${widget.title}\"?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
      actions: [
        Container(
          child: DialogButtons(
            cancelButtonText: "Cancel",
            submitButtonText: "Delete",
            showAddButton: false,
            refreshParent: widget.refreshParent,
            submitFunction: delete,
          ),
        ),
      ],
    );
  }
}
