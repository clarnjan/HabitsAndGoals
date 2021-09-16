import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:flutter/material.dart';
import '../MainMenu.dart';
import '../AddButton.dart';
import 'GoalCard.dart';

class Goals extends StatefulWidget {
  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  late List<Goal> goals;
  bool isLoading = true;
  GlobalKey<RefreshIndicatorState> refreshState =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    this.goals = await DatabaseHelper.instance.getAllGoals();
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
        title: Text('Goals'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[800],
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Flex(direction: Axis.vertical, children: [
              isLoading
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        key: refreshState,
                        onRefresh: () async {
                          await refresh();
                        },
                        child: ListView.builder(
                            itemCount: goals.length,
                            itemBuilder: (context, index) {
                              final week = goals[index];
                              return Container(
                                margin: index == goals.length - 1
                                    ? EdgeInsets.only(bottom: 50)
                                    : EdgeInsets.only(bottom: 0),
                                child: GoalCard(
                                    goal: week, refreshParent: refresh),
                              );
                            }),
                      ),
                    ),
            ]),
          ),
          AddButton(
            refreshParent: refresh,
            text: "Add Goal",
            position: Position.bottomRight,
            type: AddButtonType.addGoal,
          ),
        ],
      ),
    );
  }
}
