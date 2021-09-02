import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:diplomska1/Widgets/TaskCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Task> tasks;
  bool isLoading = true;
  String title = '';
  String input = '';
  String output = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    this.tasks = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> showAddTaskDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController textEditingController = TextEditingController();
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: textEditingController,
                  validator: (value) {
                    setState(() {
                      title = value!;
                    });
                    return value!.isNotEmpty ? null : "Title is mandatory";
                  },
                  decoration: InputDecoration(
                    hintText: "Title",
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    setState(() {
                      input = value!;
                    });
                    return value!.isNotEmpty ? null : "Input is mandatory";
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    hintText: "Input",
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    setState(() {
                      output = value!;
                    });
                    return value!.isNotEmpty ? null : "Output is mandatory";
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    hintText: "Output",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Add"),
              onPressed: () {
                if (formKey.currentState!.validate()){
                  final task = Task(
                    title: title,
                    description: 'default description',
                    createdTime: DateTime.now(),
                    input: int.parse(input),
                    output: int.parse(output),
                    finished: false,
                  );

                  DatabaseHelper.instance.createTask(task);
                  refresh();
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.grey[600],
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text(
                  "Habits",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                trailing: Icon(
                  Icons.checklist_rtl,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 10,
                endIndent: 10,
              ),
              ListTile(
                title: Text(
                  "Tasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                trailing: Icon(
                  Icons.task,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 10,
                endIndent: 10,
              ),
              ListTile(
                title: Text(
                  "Weeks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                trailing: Icon(
                  Icons.calendar_view_week,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 10,
                endIndent: 10,
              ),
              ListTile(
                title: Text(
                  "Goals",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                trailing: Icon(
                  Icons.adjust,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Divider(
                color: Colors.black,
                indent: 10,
                endIndent: 10,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await showAddTaskDialog(context);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[600],
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[800],
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Flex(direction: Axis.vertical, children: [
            isLoading
                ? Text('loading')
                : Expanded(
                    child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: Key(task.id.toString()),
                            onDismissed: (direction) {
                              setState(() {
                                tasks.removeAt(index);
                                DatabaseHelper.instance.deleteTask(task.id!);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('${task.title} dismissed')));
                            },
                            background: Container(color: Colors.red),
                            child: TaskCard(task: task),
                          );
                        }),
                  ),
          ]),
        ),
      ),
    );
  }
}
