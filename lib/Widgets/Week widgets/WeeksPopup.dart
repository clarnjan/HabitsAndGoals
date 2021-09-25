import 'package:diplomska1/Classes/DateService.dart';
import 'package:diplomska1/Classes/Week.dart';
import 'package:diplomska1/Widgets/Week%20widgets/WeekCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeeksPopup extends StatefulWidget {
  final bool show;
  final Week selectedWeek;

  WeeksPopup({
    required this.show,
    required this.selectedWeek,
  });

  @override
  _WeeksPopupState createState() => _WeeksPopupState();
}

class _WeeksPopupState extends State<WeeksPopup> {
  bool isLoading = false;
  List<Week> pastWeeks = [];
  List<Week> futureWeeks = [];
  final Key centerKey = ValueKey('second-sliver-list');
  final ScrollController scrollController = ScrollController();
  GlobalKey<RefreshIndicatorState> refreshState = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    addInitialData();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !isLoading) {
        addToEnd();
      }
      if (scrollController.position.pixels <= scrollController.position.minScrollExtent && !isLoading) {
        addToStart();
      }
    });
  }

  addInitialData() async {
    setState(() {
      isLoading = true;
    });
    for (DateTime startDate = widget.selectedWeek.startDate; !startDate.isAfter(widget.selectedWeek.startDate.add(Duration(days: 7 * 8)));) {
      futureWeeks.add(getWeek(startDate));
      startDate = startDate.add(Duration(days: 7));
    }
    DateTime startDate = widget.selectedWeek.startDate.subtract(Duration(days: 7));
    pastWeeks.add(getWeek(startDate));
    setState(() {
      isLoading = false;
    });
  }

  Week getWeek(DateTime startDate) {
    DateTime endDate = DateService.getEndDate(startDate);
    String title = "Week ${DateService.formatDate(startDate)} - ${DateService.formatDate(endDate)}";
    return new Week(title: title, startDate: startDate, endDate: endDate);
  }

  addToEnd() async {
    setState(() {
      isLoading = true;
    });
    DateTime startDate = futureWeeks.last.startDate.add(Duration(days: 7));
    futureWeeks.add(getWeek(startDate));
    setState(() {
      isLoading = false;
    });
  }

  addToStart() async {
    setState(() {
      isLoading = true;
    });
    DateTime startDate = pastWeeks.last.startDate.subtract(Duration(days: 7));
    pastWeeks.add(getWeek(startDate));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !widget.show,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: widget.show ? MediaQuery.of(context).size.height / 3 : 0,
        width: 180,
        child: Card(
          elevation: 3,
          color: Colors.transparent,
          child: CustomScrollView(
            controller: scrollController,
            center: centerKey,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      child: WeekCard(
                        week: pastWeeks[index],
                        isCurrent: false,
                      ),
                    );
                  },
                  childCount: pastWeeks.length,
                ),
              ),
              SliverList(
                key: centerKey,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      child: WeekCard(
                        week: futureWeeks[index],
                        isCurrent: futureWeeks[index].startDate == widget.selectedWeek.startDate,
                      ),
                    );
                  },
                  childCount: futureWeeks.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
