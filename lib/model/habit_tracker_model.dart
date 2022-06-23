import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

part 'habit_tracker_model.g.dart';

//enum TimePeriod {
  //day, week, month
//}

@JsonSerializable()
class Board {
  final String name;
  final List<Entry> entries;
  //final TimePeriod timePeriod;
  //final int frequency;

  Board(this.name, this.entries);

  bool isDateChecked(DateTime d){
    return this.entries.firstWhereOrNull(
            (e) => e.date.year == d.year &&
                e.date.month == d.month &&
                e.date.day == d.day
    ) != null;
  }

  void toggle(DateTime d) {
    var existingEntry = this.entries.firstWhereOrNull(
            (e) => e.date.year == d.year &&
            e.date.month == d.month &&
            e.date.day == d.day
    );

    if (existingEntry == null) {
      this.entries.add(Entry(d));
    } else {
      this.entries.remove(existingEntry);
    }
  }

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}

@JsonSerializable()
class Entry {
  final DateTime date;

  Entry(this.date);

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
  Map<String, dynamic> toJson() => _$EntryToJson(this);
}