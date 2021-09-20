import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPopup extends StatefulWidget {
  final bool show;

  CustomPopup({
    required this.show,
  });

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  bool isLoading = false;
  late List<int> top = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  late List<int> bottom = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  final Key centerKey = ValueKey('second-sliver-list');
  final ScrollController scrollController = ScrollController();
  GlobalKey<RefreshIndicatorState> refreshState =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        addToEnd();
      }
      if (scrollController.position.pixels <=
              scrollController.position.minScrollExtent &&
          !isLoading) {
        addToStart();
      }
    });
  }

  addToEnd() async {
    setState(() {
      isLoading = true;
    });
    var i = bottom.last + 1;
    bottom.addAll([i]);
    setState(() {
      isLoading = false;
    });
  }

  addToStart() async {
    setState(() {
      isLoading = true;
    });
    var i = top.last + 1;
    top.addAll([i]);
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
        width: 120,
        child: Card(
          elevation: 3,
          child: CustomScrollView(
            controller: scrollController,
            center: centerKey,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Item: ${top[index]}',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  },
                  childCount: top.length,
                ),
              ),
              SliverList(
                key: centerKey,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Item: ${bottom[index]}',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  },
                  childCount: bottom.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
