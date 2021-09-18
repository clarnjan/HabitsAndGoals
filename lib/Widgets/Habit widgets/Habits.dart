import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Habit.dart';
import 'package:diplomska1/Widgets/Habit%20widgets/HabitCard.dart';
import 'package:flutter/material.dart';
import '../MainMenu.dart';
import '../AddButton.dart';

class Habits extends StatefulWidget {
  @override
  _HabitsState createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  late List<Habit> habits;
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
    this.habits = await DatabaseHelper.instance.getAllHabits();
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
        title: Text('Habits'),
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
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              final habit = habits[index];
                              return Container(
                                margin: index == habits.length - 1
                                    ? EdgeInsets.only(bottom: 50)
                                    : EdgeInsets.only(bottom: 0),
                                child: HabitCard(habitId: habit.id!, refreshParent: refresh,),
                              );
                            }),
                      ),
                    ),
            ]),
          ),
          AddButton(
            refreshParent: refresh,
            text: "Add Habit",
            position: Position.bottomRight,
            type: AddButtonType.addHabit,
          ),
        ],
      ),
    );
  }
}
