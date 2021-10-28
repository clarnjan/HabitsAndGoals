import 'package:flutter/material.dart';

//Картичка за приказ на информации за ставка
class ClickableCard extends StatefulWidget {
  final String title;
  final String? effortAndBenefit;
  final Function tapFunction;
  final bool isSelectable;

  ClickableCard(
      {required this.tapFunction,
      required this.title,
      required this.isSelectable,
      this.effortAndBenefit});

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
          color: widget.isSelectable && isSelected
              ? Colors.green
              : Colors.grey.shade600,
        ),
        constraints: BoxConstraints(minHeight: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!widget.isSelectable)
              Text(
                "Title: ",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ),
              ),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            if (widget.effortAndBenefit != null)
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.effortAndBenefit.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
