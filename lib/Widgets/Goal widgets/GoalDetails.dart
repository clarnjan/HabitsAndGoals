import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:diplomska1/Widgets/Dialogs/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../ClickableCard.dart';
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
  final Key centerKey = ValueKey('second-sliver-list');
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
    this.goal = await DatabaseHelper.instance.getGoal(widget.goalId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> floatingButtonClick(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          canSelect: true,
          refreshParent: refresh,
          noteType: NoteType.Task,
          goalId: widget.goalId,
        );
      },
    );
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
                            itemCount: goal.tasks.length,
                            itemBuilder: (context, index) {
                              final item = goal.tasks[index];
                              return Container(
                                margin: index == goal.tasks.length - 1 ? EdgeInsets.only(bottom: 50) : EdgeInsets.only(bottom: 0),
                                child: ClickableCard(
                                  isSelectable: false,
                                  tapFunction: () {},
                                  title: item.title,
                                ),
                              );
                            }),
                      ),
                    ),
            ]),
          ),
          if (!isLoading)
            Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                width: 67,
                height: 67,
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: () async {
                      await floatingButtonClick(context);
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.grey.shade800,
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
