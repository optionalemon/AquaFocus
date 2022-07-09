import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/screens/Tasks/task_details.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:intl/intl.dart';
import 'package:AquaFocus/model/task_utils.dart';
import 'package:AquaFocus/screens/Tasks/add_task.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:AquaFocus/screens/signin_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  /*@override
  void didChangeDependencies() {
    context.read(pnProvider).init();
    super.didChangeDependencies();
  }*/

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Tasks'),
          ),
          body: Stack(children: <Widget>[
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TableCalendar(
                            firstDay: kFirstDay,
                            lastDay: kLastDay,
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) {
                              // Use `selectedDayPredicate` to determine which day is currently selected.
                              // If this returns true, then `day` will be marked as selected.

                              // Using `isSameDay` is recommended to disregard
                              // the time-part of compared DateTime objects.
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                // Call `setState()` when updating the selected day
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              }
                            },
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                // Call `setState()` when updating calendar format
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              // No need to call `setState()` here
                              _focusedDay = focusedDay;
                            },
                            headerStyle: HeaderStyle(
                              titleTextStyle:
                                  const TextStyle(color: Colors.white),
                              formatButtonTextStyle:
                                  const TextStyle(color: Colors.white),
                              formatButtonDecoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              rightChevronIcon: Icon(Icons.chevron_right,
                                  color: Colors.white),
                              leftChevronIcon:
                                  Icon(Icons.chevron_left, color: Colors.white),
                            ),
                            calendarStyle: CalendarStyle(
                              weekendTextStyle: TextStyle(color: Colors.white),
                              outsideTextStyle: TextStyle(color: Colors.grey),
                              defaultTextStyle: TextStyle(color: Colors.white),
                              markerDecoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.indigo),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(color: Colors.cyanAccent),
                              weekdayStyle: TextStyle(color: Colors.cyanAccent),
                            ),
                            calendarBuilders: CalendarBuilders(
                              selectedBuilder: (context, date, events) =>
                                  Container(
                                      margin: const EdgeInsets.all(4.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.lightGreenAccent
                                              .withOpacity(0.7)),
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                              todayBuilder: (context, date, events) =>
                                  Container(
                                      margin: const EdgeInsets.all(4.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.lightGreenAccent
                                              .withOpacity(0.4)),
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(color: Colors.white),
                                      )),
                            )),
                        StreamBuilder(
                            stream: taskDBS.streamQueryList(args: [
                              QueryArgsV2(
                                "user_id",
                                isEqualTo: user!.uid,
                              )
                            ]),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return const Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator());
                              }
                              final events = snapshot.data;
                              return Expanded(
                                child: Scrollbar(
                                  child: ListView.builder(
                                      //shrinkWrap: true,
                                      //physics: ScrollPhysics(),
                                      itemCount: events.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        AppTask event = events[index];
                                        return ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskDetails(event)));
                                          },
                                          title: Text(
                                            event.title,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            DateFormat('EEEE,dd MMMM, yyyy')
                                                .format(event.date),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(Icons.edit, color: Colors.white,),
                                            onPressed: () {
                                              Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEventPage(
                                  selectedDate:event.date,
                                  task: event,
                                  updateTaskDetails: () {},
                                )));
                                            },
                                          )
                                        );
                                      }),
                                ),
                              );
                            })
                      ])),
            ),
          ])),
      Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEventPage(
                                  selectedDate: _selectedDay,
                                  updateTaskDetails: () {},
                                )));
                  })))
    ]);
  }
/*
class _TaskScreenState extends State<TaskScreen> {
  late final PageController _pageController;
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());

  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  bool get canClearSelection =>
      _selectedDays.isNotEmpty || _rangeStart != null || _rangeEnd != null;

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Iterable<DateTime> days) {
    // Implementation example
    // Note that days are in selection order (same applies to events)
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return _getEventsForDays(days);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _selectedDays.clear();
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

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
    return Stack(
        children: <Widget>[
          Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Tasks'),
              ),
              body: Stack(children: <Widget>[
                Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/mainscreen.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(child: BlocBuilder<HabitBoardCubit, HabitBoardState>(
                    builder: (context, state) {
                      return Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [Colors.cyan
                                  .withOpacity(0.5), Colors.white.withOpacity(
                                  0.5)
                              ]),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: new Offset(0.0, 5)
                                )
                              ]
                          ),
                          child: Column(
                            children: [
                              ValueListenableBuilder<DateTime>(
                                valueListenable: _focusedDay,
                                builder: (context, value, _) {
                                  return _CalendarHeader(
                                    focusedDay: value,
                                    clearButtonVisible: canClearSelection,
                                    onTodayButtonTap: () {
                                      setState(() =>
                                      _focusedDay.value = DateTime.now());
                                    },
                                    onClearButtonTap: () {
                                      setState(() {
                                        _rangeStart = null;
                                        _rangeEnd = null;
                                        _selectedDays.clear();
                                        _selectedEvents.value = [];
                                      });
                                    },
                                    onLeftArrowTap: () {
                                      _pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                    onRightArrowTap: () {
                                      _pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                  );
                                },
                              ),
                              TableCalendar<Event>(
                                  firstDay: kFirstDay,
                                  lastDay: kLastDay,
                                  focusedDay: _focusedDay.value,
                                  headerVisible: false,
                                  rangeStartDay: _rangeStart,
                                  rangeEndDay: _rangeEnd,
                                  calendarFormat: _calendarFormat,
                                  rangeSelectionMode: _rangeSelectionMode,
                                  // selectedDayPredicate: (day) =>
                                  //     _selectedDays.contains(day),
                                  selectedDayPredicate: (day) => _selectedDays.contains(day),
                                  onDaySelected: _onDaySelected,
                                    onRangeSelected: _onRangeSelected,
                                    eventLoader: _getEventsForDay,
                                    startingDayOfWeek: StartingDayOfWeek.monday,
                                    onCalendarCreated: (controller) =>
                                    _pageController = controller,
                                    onPageChanged: (focusedDay) =>
                                    _focusedDay.value = focusedDay,
                                    onFormatChanged: (format) {
                                    if (_calendarFormat != format) {
                                    setState(() => _calendarFormat = format);
                                    }
                                    },
                                    calendarStyle: CalendarStyle(
                                    weekendTextStyle: TextStyle(
                                    color: Colors.white),
                                    outsideTextStyle: TextStyle(
                                        color: Colors.grey),
                                    defaultTextStyle: TextStyle(
                                        color: Colors.white),
                                    markerDecoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.indigo),
                                  ),
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekendStyle: TextStyle(
                                        color: Colors.cyanAccent),
                                    weekdayStyle: TextStyle(
                                        color: Colors.cyanAccent),
                                  ),
                                  calendarBuilders: CalendarBuilders(
                                    selectedBuilder: (context, date, events) =>
                                        Container(
                                            margin: const EdgeInsets.all(4.0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.lightGreenAccent
                                                    .withOpacity(0.7)
                                            ),
                                            child: Text(
                                              date.day.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                    todayBuilder: (context, date, events) =>
                                        Container(
                                            margin: const EdgeInsets.all(4.0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.lightGreenAccent
                                                    .withOpacity(0.4)
                                            ),
                                            child: Text(
                                              date.day.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                  )
                              ),
                              const SizedBox(height: 8.0),
                              Expanded(
                                child: ValueListenableBuilder<List<Event>>(
                                  valueListenable: _selectedEvents,
                                  builder: (context, value, _) {
                                    return ListView.builder(
                                      itemCount: value.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: BorderRadius.circular(
                                                12.0),
                                          ),
                                          child: ListTile(
                                            onTap: () =>
                                                print('${value[index]}'),
                                            title: Text('${value[index]}'),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],)
                      );
                    }
                ),
                ),
              ]
              )

          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery
                .of(context)
                .size
                .height * 0.05),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                  child: Icon(
                      Icons.add,
                    color: Colors.white),
                onPressed: () { Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEventPage())
                );
                },
                ),
            ),
            ),
        ]
    );
  }
}



class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 23.0, color: Colors.white,),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
            color: Colors.white,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
              color: Colors.white,
            ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
*/

}
