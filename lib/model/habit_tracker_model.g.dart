// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_tracker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      json['name'] as String,
      (json['entries'] as List<dynamic>)
          .map((e) => Entry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'name': instance.name,
      'entries': instance.entries,
    };

Entry _$EntryFromJson(Map<String, dynamic> json) => Entry(
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
    };
