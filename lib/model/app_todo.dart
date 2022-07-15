import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoModel {
  DateTime startDatetime; //this will be an unique id of every todoTask
  String category;
  int durationHour;
  int durationMinute;
  String austronautId;
  bool isDone;
  String docRef = "";

  ToDoModel(this.startDatetime, this.category, this.durationHour,
      this.durationMinute, this.austronautId, this.isDone);

  ToDoModel.fromDatabase(this.startDatetime, this.category, this.durationHour,
      this.durationMinute, this.austronautId, this.isDone, String ref) {
    docRef = ref;
  }
}