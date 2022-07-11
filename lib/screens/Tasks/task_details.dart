import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/model/app_task.dart';
import 'package:intl/intl.dart';
import 'package:AquaFocus/screens/Tasks/add_task.dart';

class TaskDetails extends StatefulWidget {
  AppTask task;
  TaskDetails(this.task);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  _updateDetails() async {
    AppTask tempTask = (await taskDBS.getSingle(widget.task.id))!;
    setState(() {
      widget.task = tempTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Task Details'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEventPage(
                              task: widget.task,
                              selectedDate: widget.task.date,
                              updateTaskDetails: _updateDetails,
                            )));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                final confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                title: Text("Confirm delete?"),
                                content: Text("Your task record will be gone."),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text("Delete"),
                                  )
                                ])) ??
                    false;
                if (confirm) {
                  await taskDBS.removeItem(widget.task.id);
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Colors.cyan.withOpacity(0.5),
                    Colors.white.withOpacity(0.5)
                  ]),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0.0, 5))
                  ]),
              child: ListView(
                  padding: EdgeInsets.all(size.height * 0.02),
                  children: [
                    ListTile(
                      leading: Icon(Icons.event, color: Colors.white),
                      title: Text(
                        widget.task.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.025),
                      ),
                      subtitle: Text(
                        DateFormat('EEEE,dd MMMM, yyyy')
                            .format(widget.task.date),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: size.height * 0.0125),
                    ListTile(
                        leading: Icon(Icons.short_text, color: Colors.white),
                        title: Text(
                          widget.task.description ?? 'No description available',
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBox(height: size.height * 0.0125),
                  ]),
            ),
          ),
        ]));
  }
}
