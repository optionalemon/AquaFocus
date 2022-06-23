import 'package:AquaFocus/model/habit_tracker_model.dart';
import 'package:AquaFocus/model/state.dart';
import 'package:AquaFocus/screens/habit_tracker_pages/board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class ViewBoardPage extends StatefulWidget {
  
  ViewBoardPage();

  @override
  State<ViewBoardPage> createState() => _ViewBoardPageState();
}

class _ViewBoardPageState extends State<ViewBoardPage> {
  var calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBoardCubit, HabitBoardState>(
      builder: (context, state) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(state.selectedBoard!.name),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BoardPage(state.selectedBoard))),
                child: Text('Edit'))],
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
                //var currentMonth = calendarController.visibleDays.firstWhere((element) => element.day == 1).month;
                return TableCalendar(
                  calendarController: calendarController,
                  availableCalendarFormats: {CalendarFormat.month: 'Month'},
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.cyanAccent[100]),
                    weekdayStyle: TextStyle(color: Colors.cyanAccent[100]),
                  ),
                  calendarStyle: CalendarStyle(
                    selectedColor: Colors.cyanAccent[400]?.withOpacity(0.9),
                    todayColor: Colors.cyanAccent[200]?.withOpacity(0.3),
                    markersColor: Colors.white,
                    outsideDaysVisible: false,
                    weekendStyle: TextStyle(color: Colors.cyanAccent),
                    weekdayStyle: TextStyle(color: Colors.white),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                        color: Colors. white,
                      fontSize: 16,
                    ),
                    formatButtonTextStyle:
                    TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.cyanAccent[400]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 20,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  builders: CalendarBuilders(
                    dayBuilder: (context, date, events) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                            state.selectedBoard!.isDateChecked(date)
                                ? Colors.lightGreenAccent.withOpacity(0.7)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                                style: TextStyle(
                                    //color: date.month == currentMonth
                                  color: Colors.white)
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  onDaySelected: (day, events, holidays) {
                    context.read<HabitBoardCubit>().toggleDate(state.selectedBoard, day);
                  },
                );
              }),
          ),
        ]
        ),
      );
      }
    );
  }
}
