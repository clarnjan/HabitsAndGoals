import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Goal.dart';
import 'package:diplomska1/Widgets/Dialogs/CustomDialog.dart';
import 'package:diplomska1/Widgets/Dialogs/DeleteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../ClickableCard.dart';

class GoalDetails extends StatefulWidget {
  final int goalId;
  final Function refreshParent;

  const GoalDetails({Key? key, required this.goalId, required this.refreshParent}) : super(key: key);

  @override
  _GoalDetailsState createState() => _GoalDetailsState();
}

class _GoalDetailsState extends State<GoalDetails> {
  late Goal goal;
  bool isLoading = true;
  bool isEditing = false;
  String? title;
  String? description;
  final Key centerKey = ValueKey('second-sliver-list');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
    this.title = goal.title;
    this.description = goal.description;
    setState(() {
      isLoading = false;
    });
  }

  afterDelete() async {
    await widget.refreshParent();
    Navigator.pop(context);
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

  Future<void> showDeleteDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return DeleteDialog(
          goalId: widget.goalId,
          title: goal.title,
          refreshParent: refresh,
          afterDelete: afterDelete,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: isLoading
              ? Text('loading')
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !isEditing
                        ? Container(
                            width: MediaQuery.of(context).size.width - 190,
                            child: Text(
                              goal.title,
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width - 190,
                            child: Text("Editing..."),
                          ),
                    IconButton(
                      icon: Icon(!isEditing ? Icons.delete : Icons.cancel),
                      onPressed: () {
                        if (isEditing) {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        } else {
                          showDeleteDialog();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(!isEditing ? Icons.edit : Icons.save_outlined),
                      onPressed: () {
                        if (isEditing) {
                          if (formKey.currentState!.validate()) {
                            goal.title = title!;
                            goal.description = description;
                            DatabaseHelper.instance.updateGoal(goal);
                            setState(() {
                              isEditing = !isEditing;
                            });
                            widget.refreshParent();
                          }
                        } else {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        }
                      },
                    ),
                  ],
                )),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[800],
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Flex(direction: Axis.vertical, children: [
              if (!isLoading)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEditing)
                        Form(
                          key: formKey,
                          child: TextFormField(
                            decoration: InputDecoration(
                              label: Text(
                                "Title:",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            autofocus: true,
                            initialValue: title,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              setState(() {
                                title = value;
                              });
                              return value!.isNotEmpty ? null : "Title is mandatory";
                            },
                          ),
                        ),
                      if (!isEditing)
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Description: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      !isEditing
                          ? Text(
                              goal.description ?? 'No description added',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : TextFormField(
                              initialValue: description,
                              decoration: InputDecoration(
                                  label: Text(
                                "Description:",
                                style: TextStyle(color: Colors.white),
                              )),
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: (value) {
                                setState(() {
                                  description = value;
                                });
                              },
                              style: TextStyle(color: Colors.white),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 20,
                        thickness: 2,
                      ),
                      Text(
                        "Tasks:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              isLoading
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
