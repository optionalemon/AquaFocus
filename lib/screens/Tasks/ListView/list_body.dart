import 'dart:collection';
import 'package:AquaFocus/screens/Tasks/ListView/all_list.dart';
import 'package:AquaFocus/screens/Tasks/ListView/tag_list.dart';
import 'package:AquaFocus/screens/Tasks/ListView/today_list.dart';
import 'package:AquaFocus/widgets/loading.dart';
import 'package:AquaFocus/screens/Tasks/task_utils.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../model/app_task.dart';
import '../../signin_screen.dart';

class ListBodyPage extends StatefulWidget {
  const ListBodyPage({Key? key}) : super(key: key);

  @override
  State<ListBodyPage> createState() => _ListBodyPageState();
}

class _ListBodyPageState extends State<ListBodyPage> {
  String dateToday = DateFormat('dd').format(DateTime.now());
  List<AppTask> eventList = [];
  bool loading = true;
  late ValueNotifier<List<AppTask>> _selectedEvents;
  LinkedHashMap<DateTime, List<AppTask>> kEvents =
      LinkedHashMap<DateTime, List<AppTask>>();
  DateTime _selectedDay = DateTime.now();
  late List tagList;

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  groupEvents(List<AppTask>? events) {
    Map<DateTime, List<AppTask>> groupedEvents = {};
    if (events != null) {
      for (var event in events) {
        DateTime date =
            DateTime.utc(event.date.year, event.date.month, event.date.day, 12);
        if (groupedEvents[date] == null) groupedEvents[date] = [];
        groupedEvents[date]!.add(event);
      }
    }
    return groupedEvents;
  }

  List<AppTask> _getEventsForDay(DateTime? day) {
    _getEvents();
    Map<DateTime, List<AppTask>> groupedEvents = groupEvents(eventList);
    kEvents = LinkedHashMap<DateTime, List<AppTask>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(groupedEvents);
    return day == null ? [] : (kEvents[day] ?? []);
  }

  _getEvents() async {
    eventList = await taskDBS.getQueryList(args: [
      QueryArgsV2(
        "userId",
        isEqualTo: user!.uid,
      ),
    ]);
    eventList.sort(((a, b) => a.date.compareTo(b.date)));
    

    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

    return loading
        ? Loading()
        : Stack(
            children: [
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
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: size.height * 0.2,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListToday(
                                        selectedEvents: _selectedEvents,
                                      )));
                        },
                        child: DottedBorder(
                          color: Colors.white,
                          padding: EdgeInsets.all(6),
                          radius: Radius.circular(15),
                          borderType: BorderType.RRect,
                          dashPattern: const [8, 4],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  Stack(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        size: size.width * 0.15,
                                      ),
                                      Positioned(
                                        top: size.height * 0.01875,
                                        left: size.width * 0.04,
                                        child: Text(
                                          dateToday,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Alata',
                                              fontSize: 30),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    " Today",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Alata',
                                        fontSize: 30),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.3,
                                  ),
                                  Text(
                                    "${_selectedEvents.value.length}",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 22, 91, 147),
                                        fontFamily: 'Alata',
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      width: double.infinity,
                      height: size.height * 0.2,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListAll(
                                        eventList: eventList,
                                      )));
                        },
                        child: DottedBorder(
                          color: Colors.white,
                          padding: EdgeInsets.all(6),
                          radius: Radius.circular(15),
                          borderType: BorderType.RRect,
                          dashPattern: const [8, 4],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  Icon(
                                    Icons.all_inbox,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: size.width * 0.15,
                                  ),
                                  const Text(
                                    " All      ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Alata',
                                        fontSize: 30),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.3,
                                  ),
                                  Text(
                                    "${eventList.length}",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 44, 81, 175),
                                        fontFamily: 'Alata',
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      width: double.infinity,
                      height: size.height * 0.2,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(colors: [
                            Colors.indigo.withOpacity(0.7),
                            Colors.white.withOpacity(0.7)
                          ]),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0.0, 5))
                          ]),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListTag()));
                        },
                        child: DottedBorder(
                          color: Colors.white,
                          padding: EdgeInsets.all(6),
                          radius: Radius.circular(15),
                          borderType: BorderType.RRect,
                          dashPattern: const [8, 4],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  Icon(
                                    Icons.tag,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: size.width * 0.15,
                                  ),
                                  const Text(
                                    " Tags",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Alata',
                                        fontSize: 30),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.3,
                                  ),
                                  Wrap(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                                          updateTaskDetails: () {},
                                        )));
                          })))
            ],
          );
  }
}
