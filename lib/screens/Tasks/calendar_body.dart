import 'dart:collection';

import 'package:AquaFocus/loading.dart';
import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:AquaFocus/screens/Tasks/task_details.dart';
import 'package:AquaFocus/screens/Tasks/task_utils.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/app_task.dart';

class CalendarBody extends StatefulWidget {
  const CalendarBody({Key? key}) : super(key: key);

  @override
  State<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late ValueNotifier<List<AppTask>> _selectedEvents;
  DateTime? _selectedDay;
  LinkedHashMap<DateTime, List<AppTask>> kEvents =
      LinkedHashMap<DateTime, List<AppTask>>();
  List<AppTask> eventList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
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

  _getEvents() async {
    eventList = await taskDBS.getQueryList(args: [
      QueryArgsV2(
        "userId",
        isEqualTo: user!.uid,
      ),
    ]);
    if (!mounted) return;
    setState(() {
      loading = false;
    });
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

  List<AppTask> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      if (!mounted) return;
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if (!mounted) return;
    setState(() {
      _selectedDay = focusedDay;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loading
        ? const Loading()
        :Stack(children: <Widget>[
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              TableCalendar(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  onRangeSelected: _onRangeSelected,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: _onDaySelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      if (!mounted) return;
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  headerStyle: HeaderStyle(
                    titleTextStyle: const TextStyle(color: Colors.white),
                    formatButtonTextStyle: const TextStyle(color: Colors.white),
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.white),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.white),
                  ),
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle(color: Colors.white),
                    outsideTextStyle:
                        TextStyle(color: Color.fromARGB(255, 196, 196, 196)),
                    defaultTextStyle: TextStyle(color: Colors.white),
                    markerDecoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.indigo),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.cyanAccent),
                    weekdayStyle: TextStyle(color: Colors.cyanAccent),
                  ),
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.lightGreenAccent.withOpacity(0.7)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                    todayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.lightGreenAccent.withOpacity(0.4)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                  )),
              Expanded(
                child: Scrollbar(
                  child: ValueListenableBuilder<List<AppTask>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                            itemCount: value.length,
                            itemBuilder: (BuildContext context, int index) {
                              AppTask event = value[index];
                              return ListTile(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TaskDetails(event)));
                                    _selectedDay = null;
                                    _selectedEvents.value = [];
                                  },
                                  title: Text(
                                    event.title,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    DateFormat('EEEE, dd MMMM, yyyy')
                                        .format(event.date),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      event.isCompleted
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      event.isCompleted = true;
                                      await taskDBS.updateData(event.id, {
                                        'isCompleted': true,
                                      });
                                    },
                                  ));
                            });
                      }),
                ),
              )
            ])),
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
                                        selectedDate: _selectedDay,
                                        updateTaskDetails: () {},
                                      )));
                          _selectedDay = null;
                          _selectedEvents.value = [];
                        })))
    ]);
  }
}