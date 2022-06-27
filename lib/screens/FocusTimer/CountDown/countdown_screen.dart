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
  Duration duration = Duration(seconds: 1500);
  Duration initialDur = Duration(seconds: 1500);
  Timer? timer;
  bool hvStarted = false;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    hvStarted = true;
    initialDur = duration;
    timer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer(bool isComplete) {
    hvStarted = false;
    duration = initialDur;
    timer!.cancel();
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = duration.inSeconds - reduceSecondsBy;
      if (duration.inSeconds == 0 && hvStarted) {
        timer!.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List currTimeStr = CountDownHelper().timeString(duration.inSeconds);
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
            SizedBox(height: screenSize.height * 0.1),
            Container(
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  Image.asset(
                    'assets/images/hourglass.png',
                    height: screenSize.height * 0.35,
                  ),
                  hvStarted
                      ? SizedBox(height: screenSize.height * 0.05)
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTimeCard(currTimeStr[0], 'HOURS'),
                      hvStarted
                          ? Container()
                          : RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                value: duration.inHours.toDouble(),
                                onChanged: (newHour) {
                                  setState(() {
                                    duration = Duration(
                                        hours: newHour.toInt(),
                                        minutes: duration.inMinutes -
                                            duration.inHours * 60,
                                        seconds: duration.inSeconds -
                                            duration.inMinutes * 60);
                                  });
                                },
                                min: 0,
                                max: 5,
                                divisions: 5,
                              )),
                      buildTimeCard(currTimeStr[1], 'MINUTES'),
                      hvStarted
                          ? Container()
                          : RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                value: duration.inMinutes.toDouble() -
                                    duration.inHours * 60,
                                onChanged: (newMinutes) {
                                  setState(() {
                                    duration = Duration(
                                        hours: duration.inHours,
                                        minutes: newMinutes.toInt(),
                                        seconds: duration.inSeconds -
                                            duration.inMinutes * 60);
                                  });
                                },
                                min: 0,
                                max: 59,
                              )),
                      buildTimeCard(currTimeStr[2], 'SECONDS'),
                      hvStarted
                          ? Container()
                          : RotatedBox(
                              quarterTurns: 3,
                              child: Slider(
                                value: duration.inSeconds.toDouble() -
                                    duration.inMinutes * 60,
                                onChanged: (newSeconds) {
                                  setState(() {
                                    duration = Duration(
                                        hours: duration.inHours,
                                        minutes: duration.inMinutes -
                                            duration.inHours * 60,
                                        seconds: newSeconds.toInt());
                                  });
                                },
                                min: 0,
                                max: 59,
                              )),
                    ],
                  ),
                  _countDownButtons(),
                  hvStarted
                      ? Container()
                      : Text(
                          "Must be more than 10 seconds~",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
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
            : duration.inSeconds >= 10
                ? CountDownButtons(text: "Start!", press: () => startTimer())
                : CountDownButtons(text: "Start!", press: null),
      ],
    );
  }

  _startedDisplay() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          duration.inSeconds != 0
              ? CountDownButtons(
                  text: 'Cancel',
                  press: () {
                    showDialog(
                        context: context, builder: (_) => _cancelTaskDialog());
                  },
                )
              : CountDownButtons(
                  text: 'Done',
                  press: () {
                    showDialog(
                        context: context,
                        builder: (_) => _completeTaskDialog());
                  },
                )
        ]);
  }

  _cancelTaskDialog() {
    return AlertDialog(
        title: const Text("Are you sure to cancel?"),
        content: Text(
            "Money will not be earned. You cannot rescue the creatures :("),
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
                    stopTimer(false);
                  });
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("Your task has been cancelled"),
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
    List totalTime = CountDownHelper().timeString(initialDur.inSeconds);
    return AlertDialog(
      title: const Text("Congrats!"),
      content: Text("You have finished ${totalTime[0]} hours ${totalTime[1]} minutes and ${totalTime[2]} seconds" ),
      actions: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              stopTimer(true);
            });
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
          padding: hvStarted ? EdgeInsets.all(8) : EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color.fromARGB(172, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 60,
              ),
            ),
          ),
        ),
        SizedBox( height: 15),
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
