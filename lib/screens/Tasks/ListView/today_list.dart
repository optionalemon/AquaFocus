import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:AquaFocus/screens/Tasks/task_details.dart';
import 'package:AquaFocus/screens/Tasks/task_utils.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../model/app_task.dart';

class ListToday extends StatefulWidget {
  ListToday(
      {Key? key,
      required this.selectedEvents,
      required this.showCompleted,
      required this.updateHomeMoney,
      required this.getMainPageEvents})
      : super(key: key);

  ValueNotifier<List<AppTask>> selectedEvents;
  final bool showCompleted;
  final updateHomeMoney;
  final getMainPageEvents;

  @override
  State<ListToday> createState() => _ListTodayState();
}

class _ListTodayState extends State<ListToday> {
  ifEventCompleted(AppTask event, int index) async {
    if (!event.isCompleted) {
      setState(() {
        widget.selectedEvents.value[index].isCompleted = !event.isCompleted;
      });
      if (!widget.showCompleted && event.repeat == "never") {
        await Future.delayed(Duration(milliseconds: 400));
        setState(() {
          widget.selectedEvents.value
              .remove(widget.selectedEvents.value[index]);
        });
      }
      await processCompletion(event, widget.updateHomeMoney, context);
      if (event.repeat != "never") {
        updateTaskDetails();
      } else {
        widget.getMainPageEvents();
      }
    }
  }

  _onDelete(AppTask event) async {
    setState(() {
      widget.selectedEvents.value.remove(event);
    });
    await taskDBS.removeItem(event.id);
    await removeNotification(event);
    widget.getMainPageEvents(); //update Main List Page
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Task ${event.title} deleted')));
  }

  updateTaskDetails() async {
    List<AppTask> eventList = await getEventList(widget.showCompleted);
    widget.selectedEvents.value = getEventsForDay(DateTime.now(), eventList);
    widget.getMainPageEvents(); //update Main List Page
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
                                  children: const [
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
                                                          await updateTaskDetails();
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
                                          title: eventVar(event.title, event),
                                          onTap: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskDetails(event)));
                                            await updateTaskDetails();
                                          },
                                          subtitle: todayNCalendar(event),
                                          leading: IconButton(
                                            icon: complStatusIcon(event),
                                            onPressed: () async {
                                              if (!event.isCompleted) {
                                                //TODO
                                                ifEventCompleted(event, index);
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
