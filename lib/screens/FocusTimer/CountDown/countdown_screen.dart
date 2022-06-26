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
                  hvStarted?Container():Text("Must be more than 10 minutes~",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
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
            : duration.inMinutes >= 10? CountDownButtons(text: "Start!", 
            press: () => startTimer()) 
            : CountDownButtons(text: "Start!", 
            press: null),
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
                    showDialog(
                        context: context, builder: (_) => _cancelTaskDialog());
                  },
                )
              ]);
  }

  _cancelTaskDialog() {
    return AlertDialog(
        title: const Text("Are you sure to cancel?"),
        content:
            Text("Money will not be earned. You cannot rescue the creatures :("),
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
          padding: hvStarted ? EdgeInsets.all(8) : EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color.fromARGB(172, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: 60,
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
