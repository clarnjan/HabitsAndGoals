import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogButtons extends StatelessWidget {
  final String cancelButtonText;
  final String submitButtonText;
  final String? newButtonText;
  final Function refreshParent;
  final Function submitFunction;
  final Function? addFunction;
  final bool showAddButton;
  const DialogButtons(
      {Key? key,
      required this.cancelButtonText,
      required this.submitButtonText,
      required this.refreshParent,
      required this.submitFunction,
      required this.showAddButton,
      this.addFunction,
      this.newButtonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showAddButton && newButtonText != null)
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: Text(
                  newButtonText!,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () async {
                  if (addFunction != null) {
                    await addFunction!(context);
                  }
                },
              ),
            ),
          ),
        TextButton(
          child: Text(
            cancelButtonText,
            style: TextStyle(fontSize: 20, color: Colors.green),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        SizedBox(
          width: 10,
        ),
        TextButton(
            child: Text(
              submitButtonText,
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            onPressed: () {
              submitFunction();
            })
      ],
    );
  }
}
