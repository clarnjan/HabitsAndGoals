import 'package:diplomska1/Classes/DatabaseHelper.dart';
import 'package:diplomska1/Classes/Enums.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Widgets/Week%20widgets/WeekCard.dart';
import 'package:flutter/material.dart';
import '../MainMenu.dart';
import '../AddButton.dart';

class Weeks extends StatefulWidget {
  @override
  _WeeksState createState() => _WeeksState();
}

class _WeeksState extends State<Weeks> {
  late List<Week> weeks;
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
    this.weeks = await DatabaseHelper.instance.getAllWeeks();
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
      body: SafeArea(
        child: Stack(
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
                              itemCount: weeks.length,
                              itemBuilder: (context, index) {
                                final week = weeks[index];
                                return Container(
                                  margin: index == weeks.length - 1
                                      ? EdgeInsets.only(bottom: 50)
                                      : EdgeInsets.only(bottom: 0),
                                  child: WeekCard(week: week,refreshParent: refresh),
                                );
                              }),
                        ),
                      ),
              ]),
            ),
            AddButton(refreshParent: refresh, text: "Add Week",position: Position.bottomRight, type: AddButtonType.addWeek,),
          ],
        ),
      ),
    );
  }
}
