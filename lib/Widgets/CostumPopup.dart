import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPopup extends StatefulWidget {
  final bool show;
  final Function(BuildContext context, dynamic item) builderFunction;
  final ScrollController scrollController = ScrollController();

  CustomPopup({
    required this.show,
    required this.builderFunction,
  });

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !widget.show,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: widget.show ? MediaQuery.of(context).size.height / 3 : 0,
        width: MediaQuery.of(context).size.width / 3,
        child: Card(
          elevation: 3,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                Widget item = widget.builderFunction(
                  context,
                  widget.items[index],
                );
                return item;
              },
            ),
          ),
        ),
      ),
    );
  }
}