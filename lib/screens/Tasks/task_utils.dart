import 'dart:collection';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:AquaFocus/model/app_task.dart';
import 'package:AquaFocus/services/task_firestore_service.dart';

import '../signin_screen.dart';

/*
_groupEvents(List<AppTask>? events) {
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


final _kEventSource = _groupEvents(eventList);

final kEvents = LinkedHashMap<DateTime, List<AppTask>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);


Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });
  */

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
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
