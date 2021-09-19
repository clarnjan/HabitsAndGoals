import 'package:diplomska1/Classes/DateFormatService.dart';
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
  late List<DateTime> weeks = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    setState(() {
      isLoading = true;
    });
    weeks.addAll([DateTime.now(), DateTime.now(), DateTime.now()]);
    setState(() {
      isLoading = false;
    });
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
          child: LayoutBuilder(
            builder: ((context, constraints) {
              if (!isLoading) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(DateFormatService.formatDate(weeks[index])),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                    );
                  },
                  itemCount: weeks.length,
                );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
