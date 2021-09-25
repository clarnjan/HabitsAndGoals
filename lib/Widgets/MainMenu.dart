import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[600],
      child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).popAndPushNamed("/week");
            },
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
            onTap: () {
              Navigator.of(context).popAndPushNamed("/habits");
            },
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
            onTap: () {
              Navigator.of(context).popAndPushNamed("/tasks");
            },
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
            onTap: () {
              Navigator.of(context).popAndPushNamed("/goals");
            },
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
    );
  }
}
