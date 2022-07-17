import 'package:AquaFocus/screens/Tasks/calendar_body.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/screens/Tasks/ListView/list_body.dart';

class TaskScreen extends StatefulWidget {
  bool isCheckList;
  TaskScreen({Key? key, required bool this.isCheckList}) : super(key: key);
  

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Tasks'),
          actions: [
            Container(
                margin: EdgeInsets.only(
                  right: size.width * 0.05,
                ),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isCheckList = !widget.isCheckList;
                      });
                    },
                    icon: Icon(
                      widget.isCheckList
                          ? Icons.calendar_month_outlined
                          : Icons.checklist,
                      color: Colors.white,
                    ))),
          ],
        ),
        body: widget.isCheckList
            ? ListBodyPage()
            : CalendarBody() // put the arguments here

        );
  }
}
