import 'package:AquaFocus/screens/Tasks/task_utils.dart';
import 'package:AquaFocus/screens/home_screen.dart';
import 'package:AquaFocus/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:AquaFocus/services/task_firestore_service.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:AquaFocus/model/app_task.dart';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

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
            'daily notification channel id', 'daily notification channel name',
            channelDescription: 'daily notification description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
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
