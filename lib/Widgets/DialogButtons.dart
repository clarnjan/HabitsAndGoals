import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogButtons extends StatelessWidget {
  final String cancelText;
  final String submitText;
  final Function refreshParent;
  final Function submitFunction;
  final Function? addFunction;
  final bool showAddButton;
  const DialogButtons(
      {Key? key,
      required this.cancelText,
      required this.submitText,
      required this.refreshParent,
      required this.submitFunction,
      required this.showAddButton,
      this.addFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showAddButton)
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: Text(
                  "New",
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
            cancelText,
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
              submitText,
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            onPressed: () {
              submitFunction();
            })
      ],
    );
  }
}
