import 'dart:collection';

import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime now = DateTime.now();
DateTime nowDate = DateTime(now.year, now.month, now.day);
DateTime nowTime = DateTime(1970, 1, 1, now.hour, now.minute);

processCompletion(AppTask task) {
  //set next time if have repeat
  if (task.repeat != "never") {
    DateTime nextTime = findNextTime(task);
  }

  //give reward according to streak and prevCompletionTime

  //re-sort the list
}

findNextTime(AppTask task) {}

List<AppTask> getEventsForDay(DateTime? day, List<AppTask> eventList) {
  Map<DateTime, List<AppTask>> groupedEvents = groupEvents(eventList);
  LinkedHashMap<DateTime, List<AppTask>> kEvents =
      LinkedHashMap<DateTime, List<AppTask>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(groupedEvents);
  return day == null ? [] : (kEvents[day] ?? []);
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
              ? eventVar(repeatText(event.reminder!), event)
              : Container(),
          event.hasTime
              ? (reminderText(event.reminder!) != ""
                  ? eventVar(reminderText(event.reminder!), event)
                  : Container())
              : Container(),
          event.tag != null
              ? eventVar('${event.tag}', event)
              : Container(),
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
                    ? eventVar(repeatText(event.reminder!), event)
                    : Container(),
                event.hasTime
                    ? (reminderText(event.reminder!) != ""
                        ? eventVar(reminderText(event.reminder!), event)
                        : Container())
                    : Container(),
                event.tag != null
                    ? eventVar('${event.tag}', event)
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
    color: event.isCompleted ?  Color.fromARGB(255, 201, 201, 201) :Colors.white,
  );
}

eventVar(String eventVar,AppTask event) {
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
    return "Reminder send 5 minutes before the task";
  } else if (reminders == '10min') {
    return "Reminder send 10 minutes before the task";
  } else if (reminders == '15min') {
    return "Reminder send 15 minutes before the task";
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
