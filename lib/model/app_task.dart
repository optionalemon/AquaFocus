import 'dart:convert';

class AppTask {
  final String title;
  final String id;
  final String? description;
  final DateTime date;
  final String? userId;
  bool isCompleted;
  bool hasTime;
  final DateTime? time;
  final String repeat;
  final String? reminder;
  final String? tag;

  AppTask({
    this.title = "",
    this.id = "",
    this.description,
    DateTime? date,
    this.userId,
    this.isCompleted = false,
    this.hasTime = false,
    this.time,
    this.reminder,
    this.repeat = "never",
    this.tag,
  }) : this.date = date ?? DateTime(1970);

  AppTask copyWith({
    String? title,
    String? id,
    String? description,
    DateTime? date,
    String? userId,
    bool? isCompleted,
    bool? hasTime,
    DateTime? time,
    String? repeat,
    String? reminder,
    String? tag,
  }) {
    return AppTask(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
      hasTime: hasTime ?? this.hasTime,
      time: time ?? this.time,
      repeat: repeat ?? this.repeat,
      reminder: reminder ?? this.reminder,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'userId': userId,
      'isCompleted': isCompleted,
      'hasTime': hasTime,
      'time': time?.millisecondsSinceEpoch,
      'repeat': repeat,
      'reminder': reminder,
      'tag' : tag,
    };
  }

  static AppTask? fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppTask(
      title: map['title'],
      id: map['id'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      userId: map['userId'],
      isCompleted: map['isCompleted'],
      hasTime: map['hasTime'],
      time: map['time'],
      repeat: map['repeat'],
      reminder: map['reminder'],
      tag: map['tag'],
    );
  }

  static AppTask? fromDS(String id, Map<String, dynamic> data) {
    if (data == null) return null;

    return AppTask(
      title: data['title'],
      id: id,
      description: data['description'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      userId: data['userId'],
      isCompleted: data['isCompleted'],
      hasTime: data['hasTime'],
      time: data['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['time'])
          : null,
      repeat: data['repeat'],
      reminder: data['reminder'],
      tag: data['tag'],
    );
  }

  String toJson() => json.encode(toMap());

  static AppTask? fromJson(String source) =>
      AppTask.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AppTask &&
        o.title == title &&
        o.id == id &&
        o.description == description &&
        o.date == date &&
        o.hasTime == hasTime &&
        o.time == time &&
        o.repeat == repeat &&
        o.reminder == reminder &&
        o.isCompleted == isCompleted &&
        o.tag == tag;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        id.hashCode ^
        description.hashCode ^
        date.hashCode ^
        userId.hashCode ^
        isCompleted.hashCode ^
        hasTime.hashCode ^
        time.hashCode ^
        repeat.hashCode ^
        reminder.hashCode ^
        tag.hashCode;
  }
}
