import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/material.dart';

class ExamScreen extends StatefulWidget {
  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
    constraints: const BoxConstraints.expand(),
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/mainscreen.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(child: CircleAvatar(radius: 60,backgroundColor: Colors.white,))
  );
  }
}