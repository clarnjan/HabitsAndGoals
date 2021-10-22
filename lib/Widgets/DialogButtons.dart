import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogButtons extends StatelessWidget {
  final String mainButtonText;
  final Function mainButtonFunction;
  final bool showSecondButton;
  final String? secondButtonText;
  final Function? secondButtonFunction;
  const DialogButtons(
      {Key? key,
      required this.mainButtonText,
      required this.mainButtonFunction,
      required this.showSecondButton,
      this.secondButtonText,
      this.secondButtonFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showSecondButton && secondButtonText != null)
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: Text(
                  secondButtonText!,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onPressed: () async {
                  if (secondButtonFunction != null) {
                    await secondButtonFunction!(context);
                  }
                },
              ),
            ),
          ),
        TextButton(
            child: Text(
              mainButtonText,
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            onPressed: () {
              mainButtonFunction();
            })
      ],
    );
  }
}
