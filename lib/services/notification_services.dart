import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:AquaFocus/model/app_task.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';


class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    _configureLocalTimezone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final BehaviorSubject<ReceivedNotification>
        didReceiveLocalNotificationSubject =
        BehaviorSubject<ReceivedNotification>();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    } else {
      debugPrint('notification done');
    }
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future<void> scheduleNotification(
      AppTask task, DateTime scheduledTime) async {
    print("add ${task.title}");
    print(task.hashCode);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.hashCode,
      'Your have an upcoming task!',
      '${task.title} scheduled at ${DateFormat('HH : mm').format(task.time!)}',
      await _nextInstanceOfScheduledTask(scheduledTime),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'scheduled notification channel id', 'scheduled notification channel name',
            channelDescription: 'scheduled notification description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

 Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Times up!', 'You have succesfully focused for your specified time!', platformChannelSpecifics,
        payload: 'item x');
  }

  removeNotification(AppTask task) async {
    print("remove ${task.title}");
    print(task.hashCode);
    await flutterLocalNotificationsPlugin.cancel(task.hashCode);
  }

  Future<tz.TZDateTime> _nextInstanceOfScheduledTask(
      DateTime scheduledTime) async {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute);
    return scheduledDate;
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
