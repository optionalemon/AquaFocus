int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
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
