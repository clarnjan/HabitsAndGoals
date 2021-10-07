import 'package:diplomska1/Classes/Goal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../MainMenu.dart';

class GoalDetails extends StatefulWidget {
  final int goalId;

  const GoalDetails(this.goalId, {Key? key}) : super(key: key);

  @override
  _GoalDetailsState createState() => _GoalDetailsState();
}

class _GoalDetailsState extends State<GoalDetails> {
  late Goal goal;
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
    //this.goal = await DatabaseHelper.instance.getWeek(widget.goalId);
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
        title: isLoading ? Text('loading') : Text(goal.title),
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
