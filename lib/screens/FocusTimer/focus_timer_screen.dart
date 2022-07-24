import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_screen.dart';
import 'package:AquaFocus/screens/FocusTimer/countup_screen.dart';
import 'package:flutter/material.dart';

class FocusTimerScreen extends StatefulWidget {
  final Function _updateHomeScreen;
  FocusTimerScreen(this._updateHomeScreen);

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  int currentIndex = 0;
  late final _pages;
  bool hvStarted = false;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      CountDownScreen(widget._updateHomeScreen, hvStarted, updateStart),
      CountUpScreen(widget._updateHomeScreen, hvStarted, updateStart),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void updateStart(bool newStart) {
    setState(() {
      hvStarted = newStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: hvStarted ? null : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Focus Timer'),
      ),
      bottomNavigationBar: hvStarted ? null : BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.blue[400]!.withOpacity(0.5),
        selectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_filled), label: 'Countdown'),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: 'Count up'),
        ],
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _pages.elementAt(currentIndex),
      ),
    );
  }
}
