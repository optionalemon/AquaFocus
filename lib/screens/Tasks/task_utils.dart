import 'dart:collection';

import 'package:AquaFocus/main.dart';
import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/services/notification_services.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime now = DateTime.now();
DateTime nowDate = DateTime(now.year, now.month, now.day);
DateTime nowTime = DateTime(1970, 1, 1, now.hour, now.minute);

ifStreak(AppTask task, Size size) {
  if (task.repeat != 'never') {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.local_fire_department,
          color: Color.fromARGB(255, 255, 85, 0),
        ),
        SizedBox(width: size.width * 0.02),
        Text('Streak ${task.streak + 1}'),
      ],
    );
  }
  return Container();
}

_noMoneyTaskDialog(context) {
  AlertDialog alert = AlertDialog(
    title: const Text("No money is awarded"),
    content: Wrap(
      children: const [
        Text(
            "You have completed the task within the same repeated duration as the previous task."),
      ],
    ),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: Text("Back"),
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

_completeTaskDialog(int moneyEarned, int fishMoney, BuildContext context,
    Function updateHomeMoney, AppTask task) {
  Size size = MediaQuery.of(context).size;

  AlertDialog alert = AlertDialog(
    title: const Text("Congrats!"),
    content: Wrap(children: [
      Column(
        children: [
          ifStreak(task, size),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/money.png',
                height: size.height * 0.035,
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                '$moneyEarned',
              ),
            ],
          )
        ],
      ),
    ]),
    actions: [
      ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
          updateHomeMoney(moneyEarned + fishMoney);
          await DatabaseServices().addMoney(moneyEarned);
        },
        child: Text("Back"),
      ),
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

processCompletion(
    AppTask task, Function updateHomeMoney, BuildContext context) async {
  DateTime? nextTime = null;
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Task ${task.title} completed')));
  await removeNotification(task);
  await taskDBS.updateData(task.id, {
    'isCompleted': task.isCompleted,
  });
  

  //set next time if have repeat
  if (task.repeat != "never") {
    nextTime = findNextTime(task);
  }
  //give reward according to streak and prevCompletionTime -> sync database and home screen + explain two completion within a day/week/month so no reward
  if (giveMoney(task)) {
    int currMoney = await DatabaseServices().getMoney();
    int moneyAdded = (task.streak + 1) * (task.streak + 1);
    if (task.repeat == 'never') {
      moneyAdded = 5;
    }
    if (task.repeat != "never") {
      if (task.hasTime) {
        await taskDBS.updateData(task.id, {
          'prevCompletionTime': now.millisecondsSinceEpoch,
          'streak': task.streak + 1,
          'date': DateTime(nextTime!.year, nextTime.month, nextTime.day)
              .millisecondsSinceEpoch,
          'time': nextTime.millisecondsSinceEpoch,
          'isCompleted': false,
        });
        AppTask? event = await taskDBS.getSingle(task.id);
        await addNotification(event!);
      } else {
        await taskDBS.updateData(task.id, {
          'prevCompletionTime': now.millisecondsSinceEpoch,
          'streak': task.streak + 1,
          'date': DateTime(nextTime!.year, nextTime.month, nextTime.day)
              .millisecondsSinceEpoch,
          'isCompleted': false,
        });
      }
    }
    return _completeTaskDialog(
        moneyAdded, currMoney, context, updateHomeMoney, task);
  } else {
    if (task.repeat != "never") {
      if (task.hasTime) {
        await taskDBS.updateData(task.id, {
          'prevCompletionTime': now.millisecondsSinceEpoch,
          'streak': task.streak,
          'date': DateTime(nextTime!.year, nextTime.month, nextTime.day)
              .millisecondsSinceEpoch,
          'time': nextTime.millisecondsSinceEpoch,
          'isCompleted': false,
        });
        AppTask? event = await taskDBS.getSingle(task.id);
        await addNotification(event!);
      } else {
        await taskDBS.updateData(task.id, {
          'prevCompletionTime': now.millisecondsSinceEpoch,
          'streak': task.streak,
          'date': DateTime(nextTime!.year, nextTime.month, nextTime.day)
              .millisecondsSinceEpoch,
          'isCompleted': false,
        });
      }
    }
    return _noMoneyTaskDialog(context);
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

bool giveMoney(AppTask task) {
  if (task.repeat == 'never') {
    return true;
  }
  if (task.repeat == 'daily' ||
      task.repeat == 'weekdays' ||
      task.repeat == 'weekends') {
    if (task.prevCompletionTime.isBefore(nowDate)) {
      return true;
    }
  } else if (task.repeat == 'weekly') {
    if (now.weekday - task.prevCompletionTime.weekday < 0) {
      return true;
    } else if (daysBetween(task.prevCompletionTime, now) >= 7) {
      return true;
    }
  } else if (task.repeat == 'monthly') {
    if (task.prevCompletionTime.month != now.month) {
      return true;
    }
  }
  return false;
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return add(
      Duration(
        days: (day - weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}

findNextTime(AppTask task) {
  DateTime nextDate;
  if (task.repeat == "daily") {
    nextDate = nowDate.add(const Duration(days: 1));
    while (!nextDate.isAfter(task.date)) {
      nextDate = nextDate.add(const Duration(days: 1));
    }
  } else if (task.repeat == "weekdays") {
    if (nowDate.weekday >= 5) {
      nextDate = nowDate.next(DateTime.monday);
    } else {
      nextDate = nowDate.add(const Duration(days: 1));
    }
    while (!nextDate.isAfter(task.date)) {
      if (nextDate.weekday >= 5) {
        nextDate = nextDate.next(DateTime.monday);
      } else {
        nextDate = nextDate.add(const Duration(days: 1));
      }
    }
  } else if (task.repeat == "weekends") {
    if (nowDate.weekday != 6) {
      nextDate = nowDate.next(DateTime.saturday);
    } else {
      nextDate = nowDate.add(const Duration(days: 1));
    }
    while (!nextDate.isAfter(task.date)) {
      if (nextDate.weekday != 6) {
        nextDate = nextDate.next(DateTime.saturday);
      } else {
        nextDate = nextDate.add(const Duration(days: 1));
      }
    }
  } else if (task.repeat == "weekly") {
    nextDate = task.date.add(const Duration(days: 7));
    while (!nextDate.isAfter(nowDate)) {
      nextDate = nextDate.add(const Duration(days: 7));
    }
  } else {
    //monthly
    nextDate = DateTime(task.date.year, task.date.month + 1, task.date.day);
    while (!nowDate.isBefore(nextDate)) {
      nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
    }
  }
  if (task.hasTime) {
    nextDate = DateTime(nextDate.year, nextDate.month, nextDate.day,
        task.time!.hour, task.time!.minute);
  }
  return nextDate;
}

List<AppTask> getEventsForDay(DateTime? day, List<AppTask> eventList) {
  Map<DateTime, List<AppTask>> groupedEvents = groupEvents(eventList);
  LinkedHashMap<DateTime, List<AppTask>> kEvents =
      LinkedHashMap<DateTime, List<AppTask>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(groupedEvents);
  return day == null ? [] : (kEvents[day] ?? []);
}

removeNotification(AppTask task) async {
  if (isScheduledEvent(task) != null) {
    await NotifyHelper().removeNotification(task);
  }
}

addNotification(AppTask event) async {
  DateTime? scheduledTime = isScheduledEvent(event);
  if (scheduledTime != null) {
    await notifyHelper.scheduleNotification(event, scheduledTime);
  }
}

DateTime? isScheduledEvent(AppTask event) {
  if (event.reminder != "never") {
    print(event.reminder);
    DateTime scheduledTime = DateTime(event.date.year, event.date.month,
        event.date.day, event.time!.hour, event.time!.minute);
    if (event.reminder == '5min') {
      scheduledTime = scheduledTime.subtract(Duration(minutes: 5));
    } else if (event.reminder == '10min') {
      scheduledTime = scheduledTime.subtract(Duration(minutes: 10));
    } else if (event.reminder == '15min') {
      scheduledTime = scheduledTime.subtract(Duration(minutes: 15));
    }
    if (scheduledTime.isAfter(now)) {
      return scheduledTime;
    }
  }
  return null;
}

Future<List<AppTask>> getEventList(bool showCompleted) async {
  List<AppTask> eventList = [];
  if (showCompleted) {
    eventList = await taskDBS.getQueryList(args: [
      QueryArgsV2(
        "userId",
        isEqualTo: user!.uid,
      ),
    ]);
  } else {
    eventList = await taskDBS.getQueryList(args: [
      QueryArgsV2(
        "userId",
        isEqualTo: user!.uid,
      ),
      QueryArgsV2(
        "isCompleted",
        isEqualTo: false,
      ),
    ]);
  }
  eventList.sort(taskCompare);
  return eventList;
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

Widget? allNTag(AppTask event) {
  return Wrap(
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          eventDate(event),
          eventTime(event),
          repeatText(event.repeat) != ""
              ? eventVar(repeatText(event.repeat), event)
              : Container(),
          event.hasTime
              ? (reminderText(event.reminder!) != ""
                  ? eventVar(reminderText(event.reminder!), event)
                  : Container())
              : Container(),
          event.tag != null ? eventVar('# ${event.tag}', event) : Container(),
        ],
      ),
    ],
  );
}

Widget? todayNCalendar(AppTask event) {
  return hasSubtitle(event)
      ? Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventTime(event),
                repeatText(event.repeat) != ""
                    ? eventVar(repeatText(event.repeat), event)
                    : Container(),
                event.hasTime
                    ? (reminderText(event.reminder!) != ""
                        ? eventVar(reminderText(event.reminder!), event)
                        : Container())
                    : Container(),
                event.tag != null
                    ? eventVar('# ${event.tag}', event)
                    : Container(),
              ],
            ),
          ],
        )
      : null;
}

bool expiredDate(AppTask event) {
  DateTime eventDate =
      DateTime(event.date.year, event.date.month, event.date.day);
  return eventDate.isBefore(nowDate);
}

complStatusIcon(AppTask event) {
  return Icon(
    event.isCompleted ? Icons.check_circle : Icons.circle_outlined,
    color:
        event.isCompleted ? Color.fromARGB(255, 201, 201, 201) : Colors.white,
  );
}

eventVar(String eventVar, AppTask event) {
  return Text(
    eventVar,
    style: event.isCompleted
        ? const TextStyle(color: Color.fromARGB(255, 201, 201, 201))
        : const TextStyle(color: Colors.white),
  );
}

eventDate(AppTask event) {
  TextStyle style;
  if (event.isCompleted) {
    style = TextStyle(color: Color.fromARGB(255, 201, 201, 201));
  } else if (expiredDate(event)) {
    style = TextStyle(color: Colors.red);
  } else {
    style = TextStyle(color: Colors.white);
  }
  return Text(
    DateFormat('dd/MM/yy').format(event.date),
    style: style,
  );
}

bool expiredTime(AppTask event) {
  DateTime eventDate =
      DateTime(event.date.year, event.date.month, event.date.day);

  DateTime eventTime =
      DateTime(1970, 1, 1, event.time!.hour, event.time!.minute);
  return expiredDate(event) ||
      (eventTime.isBefore(nowTime) && eventDate.isAtSameMomentAs(nowDate));
}

eventTime(AppTask event) {
  if (!event.hasTime) {
    return Container();
  }
  TextStyle style;
  if (event.isCompleted) {
    style = TextStyle(color: Color.fromARGB(255, 201, 201, 201));
  } else if (expiredTime(event)) {
    style = TextStyle(color: Colors.red);
  } else {
    style = TextStyle(color: Colors.white);
  }
  return Text(
    DateFormat('HH : mm').format(event.time!),
    style: style,
  );
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

int taskCompare(AppTask a, AppTask b) {
  DateTime aDate = DateTime(a.date.year, a.date.month, a.date.day);
  DateTime bDate = DateTime(b.date.year, b.date.month, b.date.day);

  if (a.isCompleted && !b.isCompleted) {
    return 1;
  } else if (!a.isCompleted && b.isCompleted) {
    return -1;
  }

  if (aDate.compareTo(bDate) == 0) {
    if (a.time != null && b.time != null) {
      DateTime aTime = DateTime(1970, 1, 1, a.time!.hour, a.time!.minute);
      DateTime bTime = DateTime(1970, 1, 1, b.time!.hour, b.time!.minute);

      return aTime.compareTo(bTime);
    } else if (a.time == null && b.time != null) {
      return 1;
    }
    return -1;
  }
  return (aDate.compareTo(bDate));
}

String repeatText(String repeats) {
  if (repeats == 'daily') {
    return "Repeats Daily";
  } else if (repeats == 'weekdays') {
    return "Repeat on weekdays";
  } else if (repeats == 'weekends') {
    return "Repeat on weekends";
  } else if (repeats == 'weekly') {
    return "Repeat weekly";
  } else if (repeats == 'monthly') {
    return "Repeat monthly";
  }
  return "";
}

bool hasSubtitle(AppTask event) {
  if (event.hasTime) {
    return true;
  }
  if (event.tag != null) {
    return true;
  }
  if (repeatText(event.repeat) != "") {
    return true;
  }
  return false;
}

String reminderText(String reminders) {
  if (reminders == 'ontime') {
    return "Reminder send on time";
  } else if (reminders == '5min') {
    return "Reminder send 5 minutes before";
  } else if (reminders == '10min') {
    return "Reminder send 10 minutes before";
  } else if (reminders == '15min') {
    return "Reminder send 15 minutes before";
  }
  return "";
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 10, kToday.month, kToday.day);
