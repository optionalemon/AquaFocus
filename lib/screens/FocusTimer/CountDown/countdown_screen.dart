import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_buttons.dart';
import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_helper.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'countdown_helper.dart';

class CountDownScreen extends StatefulWidget {
  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  Duration duration = const Duration(seconds: 30); //TODO intake
  Duration initialDur = const Duration(seconds: 30); //TODO intake
  Timer? timer;
  bool hvStarted = false;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    hvStarted = true;
    timer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    hvStarted = false;
    duration = initialDur;
    timer!.cancel();
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = duration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        stopTimer();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List currTime = CountDownHelper().timeString(duration.inSeconds);
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mainscreen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.15),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/hourglass.png',
                    height: screenSize.height * 0.35,
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTimeCard(currTime[0], 'HOURS'),
                      const SizedBox(
                        width: 8,
                      ),
                      buildTimeCard(currTime[1], 'MINUTES'),
                      const SizedBox(
                        width: 8,
                      ),
                      buildTimeCard(currTime[2], 'SECONDS'),
                    ],
                  ),
                  _countDownButtons(),
                ],
              ),
            ),
          ],
        ));
  }

  _countDownButtons() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.024),
        hvStarted
            ? _startedDisplay()
            : CountDownButtons(text: "Start!", press: () => startTimer()),
      ],
    );
  }

  _startedDisplay() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CountDownButtons(
            text: 'Cancel',
            press: () {
              showDialog(context: context, builder: (_) => _cancelTaskDialog());
            },
          )
        ]);
  }

  _cancelTaskDialog() {
    return AlertDialog(
        title: const Text("Are you sure to cancel?"),
        content:
            Text("No money will be earned. You cannot rescue the creatures :("),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    stopTimer();
                  });
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("You task have been cancelled"),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Back"),
                              ),
                            ],
                          ));
                },
                child: Text("Yes"),
              ),
            ],
          )
        ]);
  }

  _completeTaskDialog() {
    return AlertDialog(
      title: const Text("Congrats!"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Back"),
        ),
      ],
    );
  }

  buildTimeCard(String time, String title) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color.fromARGB(172, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 72,
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
