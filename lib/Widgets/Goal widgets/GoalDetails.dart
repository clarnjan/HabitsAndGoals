import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Tables/Goal.dart';
import 'package:diplomska1/Classes/Tables/Task.dart';
import 'package:diplomska1/Widgets/Dialogs/AddOrSelectDialog.dart';
import 'package:diplomska1/Widgets/Dialogs/EditDialog.dart';
import 'package:diplomska1/Widgets/Shared%20widgets/EmptyState.dart';
import 'package:diplomska1/Widgets/Task%20widgets/TaskCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class GoalDetails extends StatefulWidget {
  final int goalId;
  final Function refreshParent;

  const GoalDetails(
      {Key? key, required this.goalId, required this.refreshParent})
      : super(key: key);

  @override
  _GoalDetailsState createState() => _GoalDetailsState();
}

class _GoalDetailsState extends State<GoalDetails> {
  Goal? goal;
  bool isLoading = true;
  int tasksEffort = 0;
  int tasksBenefit = 0;
  final Key centerKey = ValueKey('second-sliver-list');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
    this.goal = await DatabaseHelper.instance.getGoal(widget.goalId);
    await updateTasksEffortAndBenefit();
    setState(() {
      isLoading = false;
    });
  }

  //Ажурирање на напорот и придобивката
  updateTasksEffortAndBenefit() async {
    tasksEffort = 0;
    tasksBenefit = 0;
    for (Task t in goal!.tasks) {
      if (t.isFinished) {
        tasksEffort += t.effort;
        tasksBenefit += t.benefit;
      }
    }
  }

  //Штиклирање на задача
  taskCheckChanged(bool isFinished, int effort, int benefit) {
    setState(() {
      if (isFinished) {
        tasksEffort += effort;
        tasksBenefit += benefit;
      } else {
        tasksEffort -= effort;
        tasksBenefit -= benefit;
      }
    });
  }

  //Едитирање на цел
  Future<void> editGoal() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          afterDelete: afterDelete,
          refreshParent: refresh,
          noteType: NoteType.Goal,
          itemId: widget.goalId,
        );
      },
    );
  }

  //Метод кој се повикува откако некоја цел е избришена
  afterDelete() async {
    await widget.refreshParent();
    Navigator.pop(context);
  }

  //Клик на картичка
  Future<void> cardTapFunction(int id) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          afterDelete: refresh,
          refreshParent: refresh,
          noteType: NoteType.Task,
          itemId: id,
        );
      },
    );
  }

  //Клик на копчето +
  Future<void> floatingButtonClick(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AddOrSelectDialog(
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
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Goal details',
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: editGoal,
          ),
        ],
      )),
      body: Stack(
        children: [
          Container(
            color: Colors.grey.shade800,
            width: double.infinity,
            padding: EdgeInsets.all(5),
            child: Flex(direction: Axis.vertical, children: [
              if (goal != null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title: ',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        goal!.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Description: ',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        goal!.description ?? 'No description added',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 20,
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tasks:",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                          if (goal!.tasks.length > 0)
                            Text(
                              "$tasksEffort - $tasksBenefit",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              goal == null
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      child: Expanded(
                        child: RefreshIndicator(
                          key: refreshState,
                          onRefresh: () async {
                            await refresh();
                          },
                          child: goal!.tasks.length > 0
                              ? ListView.builder(
                                  itemCount: goal!.tasks.length,
                                  itemBuilder: (context, index) {
                                    final task = goal!.tasks[index];
                                    return Container(
                                      margin: index == goal!.tasks.length - 1
                                          ? EdgeInsets.only(bottom: 50)
                                          : EdgeInsets.only(bottom: 0),
                                      child: TaskCard(
                                        task: task,
                                        tapFunction: () {
                                          cardTapFunction(task.id!);
                                        },
                                        checkBoxChanged: taskCheckChanged,
                                      ),
                                    );
                                  })
                              : ListView(children: [
                                  EmptyState(
                                      text:
                                          "No tasks associated with this goal.\nClick the button below to add some"),
                                ]),
                        ),
                      ),
                    ),
            ]),
          ),
          if (goal != null)
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
