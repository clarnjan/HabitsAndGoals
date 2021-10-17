import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../MainMenu.dart';

class HabitDetails extends StatefulWidget {
  final int habitId;

  const HabitDetails(this.habitId, {Key? key}) : super(key: key);

  @override
  _HabitDetailsState createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  late Habit habit;
  bool isLoading = true;
  GlobalKey<RefreshIndicatorState> refreshState = GlobalKey<RefreshIndicatorState>();

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
    return Scaffold(
      drawer: Drawer(
        child: MainMenu(),
      ),
      appBar: AppBar(
        title: isLoading ? Text('loading') : Text(habit.title),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[800],
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
