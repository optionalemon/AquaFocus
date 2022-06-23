import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/material.dart';

class CountDownScreen extends StatefulWidget {
  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
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
    child: Center(child: CircleAvatar(radius: 60,backgroundColor: Colors.black,))
  );
  }
}
