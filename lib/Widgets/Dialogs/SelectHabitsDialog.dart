import 'package:diplomska1/Classes/Tables/Habit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Shared widgets/ClickableCard.dart';

//Дијалог за селектирање на навики
class SelectHabitsDialog extends StatefulWidget {
  final List<Habit> habits;
  final Function selectHabit;

  const SelectHabitsDialog(
      {Key? key, required this.selectHabit, required this.habits})
      : super(key: key);

  @override
  _SelectHabitsDialogState createState() => _SelectHabitsDialogState();
}

class _SelectHabitsDialogState extends State<SelectHabitsDialog> {
  @override
  Widget build(BuildContext context) {
    return widget.habits.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: widget.habits.length,
            itemBuilder: (context, index) {
              final habit = widget.habits[index];
              return Container(
                child: ClickableCard(
                  isSelectable: true,
                  title: habit.title,
                  effortAndBenefit:
                      "${habit.effortSingle * habit.repetitions} - ${habit.benefitSingle * habit.repetitions}",
                  tapFunction: () {
                    widget.selectHabit(habit);
                  },
                ),
              );
            })
        : Container(
            height: 200,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "No available habits.\nClick New to add more",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
