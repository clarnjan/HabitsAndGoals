import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:flutter/material.dart';

class AddHabitDialog extends StatefulWidget {
  final Habit? habit;
  final Function refreshParent;

  const AddHabitDialog({Key? key, this.habit, required this.refreshParent}) : super(key: key);

  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
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
              final habit = Habit(
                title: title,
                createdTime: DateTime.now(),
              );

              DatabaseHelper.instance.createHabit(habit);
              await widget.refreshParent();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
