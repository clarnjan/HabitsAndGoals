import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogButtons extends StatelessWidget {
  final String cancelText;
  final String submitText;
  final Function refreshParent;
  final Function submitFunction;
  const DialogButtons(
      {Key? key, required this.cancelText, required this.submitText, required this.refreshParent, required this.submitFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text(
            cancelText,
            style: TextStyle(fontSize: 20, color: Colors.green.shade700),
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
              style: TextStyle(fontSize: 20, color: Colors.green.shade700),
            ),
            onPressed: () {
              submitFunction();
            })
      ],
    );
  }
}
