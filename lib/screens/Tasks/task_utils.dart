import 'package:AquaFocus/model/app_task.dart';

DateTime now = DateTime.now();
DateTime nowDate = DateTime(now.year, now.month, now.day);
DateTime nowTime = DateTime(1970, 1, 1, now.hour, now.minute);

bool expiredDate(AppTask event) {
  DateTime eventDate =
      DateTime(event.date.year, event.date.month, event.date.day);
  return eventDate.isBefore(nowDate);
}

bool expiredTime(AppTask event) {
  DateTime eventDate =
      DateTime(event.date.year, event.date.month, event.date.day);

  DateTime eventTime =
      DateTime(1970, 1, 1, event.time!.hour, event.time!.minute);
  return expiredDate(event) ||
      eventTime.isBefore(nowTime) && eventDate.isAtSameMomentAs(nowDate);
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
