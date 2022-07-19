import 'dart:collection';

import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:AquaFocus/screens/Tasks/task_details.dart';
import 'package:AquaFocus/screens/Tasks/task_utils.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../model/app_task.dart';
import '../../signin_screen.dart';

class ListToday extends StatefulWidget {
  ValueNotifier<List<AppTask>> selectedEvents;

  ListToday({Key? key, required this.selectedEvents}) : super(key: key);

  @override
  State<ListToday> createState() => _ListTodayState();
}

class _ListTodayState extends State<ListToday> {
  _onDelete(AppTask event) async {
    setState(() {
      widget.selectedEvents.value.remove(event);
    });
    await taskDBS.removeItem(event.id);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Task ${event.title} deleted')));
  }

  updateTaskDetails() async {
    List<AppTask> eventList = await taskDBS.getQueryList(args: [
      QueryArgsV2(
        "userId",
        isEqualTo: user!.uid,
      ),
    ]);
    Map<DateTime, List<AppTask>> groupedEvents = {};

    for (var event in eventList) {
      DateTime date =
          DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
      if (groupedEvents[date] == null) groupedEvents[date] = [];
      groupedEvents[date]!.add(event);
    }

    LinkedHashMap<DateTime, List<AppTask>> kEvents =
        LinkedHashMap<DateTime, List<AppTask>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(groupedEvents);
    widget.selectedEvents.value = (kEvents[DateTime.now()] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Today'),
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
                    Colors.cyan.withOpacity(0.7),
                    Colors.white.withOpacity(0.7)
                  ]),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0.0, 5))
                  ]),
              child: Scrollbar(
                child: ValueListenableBuilder<List<AppTask>>(
                    valueListenable: widget.selectedEvents,
                    builder: (context, value, _) {
                      return widget.selectedEvents.value.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Wrap(
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text("No task for today!",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 59, 59, 59),
                                            fontSize: 20)),
                                  ],
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (BuildContext context, int index) {
                                AppTask event = value[index];
                                return Slidable(
                                  key: Key(event.id),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    dismissible:
                                        DismissiblePane(onDismissed: () async {
                                      await _onDelete(event);
                                    }),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddEventPage(
                                                        task: event,
                                                        selectedDate:
                                                            event.date,
                                                        updateTaskDetails:
                                                            () async {
                                                          updateTaskDetails();
                                                          setState(() {});
                                                        },
                                                      )));
                                        },
                                        backgroundColor: Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Edit',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) async {
                                          await _onDelete(event);
                                        },
                                        backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                          title: Text(
                                            event.title,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskDetails(event)));
                                            updateTaskDetails();
                                          },
                                          subtitle: hasSubtitle(event)
                                              ? Wrap(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        event.hasTime
                                                            ? Text(
                                                                DateFormat(
                                                                        'HH : mm ')
                                                                    .format(event
                                                                        .time!),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            : Container(),
                                                        repeatText(event
                                                                    .repeat) !=
                                                                ""
                                                            ? Text(
                                                                '${repeatText(event.repeat)} ',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            : Container(),
                                                        event.hasTime
                                                            ? (reminderText(event
                                                                        .reminder!) !=
                                                                    ""
                                                                ? Text(
                                                                    '${reminderText(event.reminder!)} ',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                : Container())
                                                            : Container(),
                                                        event.tag != null
                                                            ? Text(
                                                                '#${event.tag}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : null,
                                          leading: IconButton(
                                            icon: Icon(
                                              event.isCompleted
                                                  ? Icons.check_circle
                                                  : Icons.circle_outlined,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                              if (!event.isCompleted) {
                                                setState(() {
                                                  widget
                                                    .selectedEvents
                                                    .value[index]
                                                    .isCompleted =
                                                !event.isCompleted;
                                                });
                                                await taskDBS
                                                    .updateData(event.id, {
                                                  'isCompleted':
                                                      event.isCompleted,
                                                });
                                              }
                                            },
                                          )),
                                      Divider(
                                        color: Colors.white,
                                        indent: 3,
                                      ),
                                    ],
                                  ),
                                );
                              });
                    }),
              ),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                      child: Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEventPage(
                                      selectedDate: DateTime.now(),
                                      updateTaskDetails: updateTaskDetails,
                                    )));
                        setState(() {});
                      })))
        ]));
  }
}
