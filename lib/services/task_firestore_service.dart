import 'package:AquaFocus/model/app_task.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

final taskDBS = DatabaseService<AppTask>(
  'tasks',
  fromDS: (id, data) => AppTask.fromDS(id, data!)!,
  toMap: (event) => event.toMap(),
);