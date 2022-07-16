import 'package:AquaFocus/model/app_task.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:AquaFocus/screens/signin_screen.dart';

final taskDBS = DatabaseService<AppTask>(
  'users/${user?.uid}/tasks',
  fromDS: (id, data) => AppTask.fromDS(id, data!)!,
  toMap: (event) => event.toMap(),
);
