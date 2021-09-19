import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/DateFormatService.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:flutter/material.dart';

class AddWeekDialog extends StatefulWidget {
  final Task? task;
  final Function refreshParent;

  const AddWeekDialog({Key? key, this.task, required this.refreshParent})
      : super(key: key);

  @override
  _AddWeekDialogState createState() => _AddWeekDialogState();
}

class _AddWeekDialogState extends State<AddWeekDialog> {
  String title = '';
  DateTime? startDate;
  DateTime? endDate;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  pickStartDate() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final newDate = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 6))),

    );
    print(newDate);
    setState(() {
      startDate = newDate!.start;
    });
  }

  pickEndDate() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1));
    setState(() {
      endDate = newDate;
    });
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
            TextFormField(
              onTap: pickStartDate,
              validator: (value) {
                return startDate != null ? null : "Start date is mandatory";
              },
              decoration: InputDecoration(
                hintText: startDate != null
                    ? DateFormatService.formatDate(startDate!)
                    : "Select start date",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Add"),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final week =
                  Week(title: title, startDate: startDate!, endDate: endDate!);

              DatabaseHelper.instance.createWeek(week);
              await widget.refreshParent();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
