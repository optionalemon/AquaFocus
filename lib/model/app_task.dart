import 'dart:convert';

class AppTask {
  final String title;
  final String id;
  final String? description;
  final DateTime date;
  final String? userId;
  final bool? isCompleted;

  AppTask({
    this.title = "",
    this.id = "",
    this.description,
    DateTime? date,
    this.userId,
    this.isCompleted = false,
  }): this.date = date?? DateTime(1970);

  AppTask copyWith({
    String? title,
    String? id,
    String? description,
    DateTime? date,
    String? userId,
    bool? isCompleted,
  }) {
    return AppTask(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
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
    );
  }

  String toJson() => json.encode(toMap());

  static AppTask? fromJson(String source) =>
      AppTask.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppEvent(title: $title, id: $id, description: $description, date: $date, userId: $userId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AppTask &&
        o.title == title &&
        o.id == id &&
        o.description == description &&
        o.date == date &&
        o.userId == userId;
  }

  @override
  int get hashCode {
    return title.hashCode ^
    id.hashCode ^
    description.hashCode ^
    date.hashCode ^
    userId.hashCode ^ isCompleted.hashCode;
  }
}