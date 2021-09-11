import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? task;
  final Function refreshParent;

  const AddTaskDialog({Key? key, this.task, required this.refreshParent}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String title = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

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
            // TextFormField(
            //   keyboardType: TextInputType.number,
            //   validator: (value) {
            //     setState(() {
            //       input = value!;
            //     });
            //     return value!.isNotEmpty ? null : "Input is mandatory";
            //   },
            //   inputFormatters: <TextInputFormatter>[
            //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            //   ],
            //   decoration: InputDecoration(
            //     hintText: "Input",
            //   ),
            // ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Add"),
          onPressed: () async {
            if (formKey.currentState!.validate()){
              final task = Task(
                title: title,
                isRepeating: false,
                createdTime: DateTime.now(),
              );

              DatabaseHelper.instance.createTask(task);
              await widget.refreshParent();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
