import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Task.dart';
import 'package:flutter/material.dart';

class NewTask extends StatefulWidget {
  final Task? task;

  const NewTask({Key? key, this.task}) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Task Title',
                ),
                style: TextStyle(
                  fontSize: 25,
                ),
                onChanged: (String title) {
                  setState(() {
                    this.title = title;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Task DescriptionTitle',
                ),
                style: TextStyle(
                  fontSize: 20,
                ),
                onChanged: (String description) {
                  setState(() {
                    this.description = description;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  print('add button clicked');
                  final task = Task(
                  title: title,
                  description: description,
                  createdTime: DateTime.now(),
                  input: 1,
                  output: 1,
                  finished: false,
                  );

                  DatabaseHelper.instance.createTask(task);
                  if (Navigator.canPop(context))
                    Navigator.pop(context);
                  if (Navigator.canPop(context))
                    Navigator.pop(context);
                  Navigator.pushNamed(context, '/');
                },
                child: Text('Add Task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
