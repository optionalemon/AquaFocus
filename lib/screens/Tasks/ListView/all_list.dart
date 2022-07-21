import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:AquaFocus/screens/Tasks/task_details.dart';
import 'package:AquaFocus/screens/Tasks/task_utils.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../../model/app_task.dart';

class ListAll extends StatefulWidget {
  ListAll(
      {Key? key,
      required this.eventList,
      required this.showCompleted,
      required this.getMainPageEvents,
      required this.updateHomeMoney})
      : super(key: key);
  List<AppTask> eventList;
  final bool showCompleted;
  final updateHomeMoney;
  final getMainPageEvents;

  @override
  State<ListAll> createState() => _ListAllState();
}

class _ListAllState extends State<ListAll> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  ifEventCompleted(AppTask event, int index) async {
    if (!event.isCompleted) {
      setState(() {
        widget.eventList[index].isCompleted = !event.isCompleted;
      });
      if (!widget.showCompleted && event.repeat == "never") {
        await Future.delayed(Duration(milliseconds: 400));
        setState(() {
          widget.eventList.remove(event);
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

  updateTaskDetails() async {
    widget.eventList = await getEventList(widget.showCompleted);
    widget.getMainPageEvents();
    setState(() {});
  }

  _onDelete(AppTask event) async {
    setState(() {
      widget.eventList.remove(event);
    });
    await taskDBS.removeItem(event.id);
    await removeNotification(event);
    widget.getMainPageEvents();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Task ${event.title} deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('All Tasks'),
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
                    Colors.blue.withOpacity(0.7),
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
                    valueListenable: ValueNotifier(widget.eventList),
                    builder: (context, value, _) {
                      return widget.eventList.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Wrap(
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: const [
                                    Text("You have no more tasks!",
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
                                                            updateTaskDetails,
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
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
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
                                          subtitle: allNTag(event),
                                          leading: IconButton(
                                            icon: complStatusIcon(event),
                                            onPressed: () async {
                                              if (!event.isCompleted) {
                                                //TODO
                                                await ifEventCompleted(
                                                    event, index);
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
                      })))
        ]));
  }
}
