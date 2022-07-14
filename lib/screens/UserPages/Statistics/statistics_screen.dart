import 'package:AquaFocus/screens/UserPages/Statistics/focus_time_stats.dart';
import 'package:AquaFocus/screens/UserPages/Statistics/tasks_stats.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _pages = <Widget>[
    FocusTimeStats(),
    TasksStats(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          title: const Text("Statistics"),
          backgroundColor: Color.fromARGB(40, 0, 0, 0),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.blue[400]!.withOpacity(0.5),
          selectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
                icon: Icon(Icons.access_alarm), 
                label: 'Focus Time Statistics'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined), 
                label: 'Task Management Insights'
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        )
    );
  }
}
