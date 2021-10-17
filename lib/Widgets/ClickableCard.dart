import 'package:flutter/material.dart';

class ClickableCard extends StatefulWidget {
  final String title;
  final Function tapFunction;
  final bool isSelectable;

  ClickableCard({required this.tapFunction, required this.title, required this.isSelectable});

  @override
  _ClickableCardState createState() => _ClickableCardState();
}

class _ClickableCardState extends State<ClickableCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.isSelectable) {
            isSelected = !isSelected;
          }
          widget.tapFunction();
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.isSelectable && isSelected ? Colors.green : Colors.grey.shade600,
        ),
        constraints: BoxConstraints(minHeight: 70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
