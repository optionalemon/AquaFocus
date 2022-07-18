import 'package:flutter/material.dart';

class TagColors {
  final String title;
  final Color color;

  TagColors({
    required this.title,
    required this.color,
  });
}

List<TagColors> tagColors = [
  TagColors(title: "red", color: Color.fromARGB(255, 245, 107, 116)),
  TagColors(title: "orange", color: Color.fromARGB(255, 244, 167, 111)),
  TagColors(title: "yellow", color: Color.fromARGB(255, 222, 213, 76)),
  TagColors(title: "green", color: Color.fromARGB(255, 91, 220, 119)),
  TagColors(title: "blue", color: Color.fromARGB(255, 84, 164, 234)),
  TagColors(title: "indigo", color: Color.fromARGB(255, 122, 128, 177)),
  TagColors(title: "purple", color: Color.fromARGB(255, 125, 100, 226)),
];
