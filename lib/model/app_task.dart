import 'dart:convert';

class AppTask {
  final String title;
  final String? id;
  final String? description;
  final DateTime? date;
  final String? userId;

  AppTask({
    this.title = "",
    this.id,
    this.description,
    this.date,
    this.userId,
  });

  AppTask copyWith({
    String? title,
    String? id,
    String? description,
    DateTime? date,
    String? userId,
  }) {
    return AppTask(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'date': date!.millisecondsSinceEpoch,
      'userId': userId,
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
    );
  }
  static AppTask? fromDS(String id, Map<String, dynamic> data) {
    if (data == null) return null;

    return AppTask(
      title: data['title'],
      id: id,
      description: data['description'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      userId: data['user_id'],
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
    userId.hashCode;
  }
}