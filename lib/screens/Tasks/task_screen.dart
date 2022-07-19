import 'package:AquaFocus/screens/Tasks/calendar_body.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/screens/Tasks/ListView/list_body.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late bool isCheckList;
  late bool showCompleted;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getChecknCompl();
  }

  Future<void> getChecknCompl() async {
    if (user != null) {
      isCheckList = await DatabaseServices().getisCheckList();
      showCompleted = await DatabaseServices().getShowCompl();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading? Loading() : Scaffold(
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
                        isCheckList = !isCheckList;
                      });
                    },
                    icon: Icon(
                      isCheckList
                          ? Icons.calendar_month_outlined
                          : Icons.checklist,
                      color: Colors.white,
                    ))),
          ],
        ),
        body: isCheckList
            ? ListBodyPage()
            : CalendarBody() // put the arguments here

        );
  }
}
