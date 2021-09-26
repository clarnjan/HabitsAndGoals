import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Widgets/Habit%20widgets/HabitDetails.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatefulWidget {
  final int habitId;
  final Function refreshParent;
  final bool isSelectable;
  final Function? selectFunction;

  HabitCard({required this.habitId, required this.refreshParent, required this.isSelectable, this.selectFunction});

  @override
  _HabitCardState createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  late Habit habit;
  bool canDelete = false;
  bool isLoading = true;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    this.habit = await DatabaseHelper.instance.getHabit(widget.habitId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          if (widget.isSelectable) {
            setState(() {
              isSelected = !isSelected;
            });
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HabitDetails(habit)));
          }
        }
      },
      onLongPress: () {
        print('long press');
        setState(() {
          canDelete = !canDelete;
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
          color: isSelected ? Colors.green[700] : Colors.grey[600],
        ),
        constraints: BoxConstraints(minHeight: 70),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      habit.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (canDelete)
                    IconButton(
                      onPressed: () async {
                        DatabaseHelper.instance.deleteHabit(widget.habitId);
                        await widget.refreshParent();
                      },
                      icon: Icon(Icons.delete),
                    ),
                ],
              ),
      ),
    );
  }
}
