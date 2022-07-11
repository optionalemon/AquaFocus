import 'package:AquaFocus/loading.dart';
import 'package:AquaFocus/reusable_widgets/reusable_widget.dart';
import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_helper.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'countdown_helper.dart';

class CountDownScreen extends StatefulWidget {
  final Function _updateHomeScreen;
  CountDownScreen(this._updateHomeScreen);

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  Duration duration = Duration(seconds: 1500);
  Duration initialDur = Duration(seconds: 1500);
  Timer? timer;
  bool hvStarted = false;
  int fishMoney = 0;
  bool loading = true;

  Future<void> getMarMoney() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fishMoney = await DatabaseService().getMoney();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMarMoney();
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
    Size size = MediaQuery.of(context).size;
    List currTimeStr = CountDownHelper().timeString(duration.inSeconds);
    return loading
        ? const Loading()
        : Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.1),
                Column(
                  children: [
                    SizedBox(height: size.height * 0.05),
                    Image.asset(
                      'assets/images/hourglass.png',
                      height: size.height * 0.3,
                    ),
                    hvStarted
                        ? SizedBox(height: size.height * 0.05)
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTimeCard(currTimeStr[0], 'HOURS', size),
                        hvStarted
                            ? SizedBox(width: size.width * 0.02)
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
                                  activeColor: Colors.white,
                                  inactiveColor:
                                      Color.fromARGB(136, 255, 255, 255),
                                  divisions: 5,
                                )),
                        buildTimeCard(currTimeStr[1], 'MINUTES', size),
                        hvStarted
                            ? SizedBox(width: size.width * 0.02)
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
                                  activeColor: Colors.white,
                                  inactiveColor:
                                      Color.fromARGB(136, 255, 255, 255),
                                )),
                        buildTimeCard(currTimeStr[2], 'SECONDS', size),
                        hvStarted
                            ? SizedBox(width: size.width * 0.02)
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
                                  activeColor: Colors.white,
                                  inactiveColor:
                                      Color.fromARGB(136, 255, 255, 255),
                                )),
                      ],
                    ),
                    _countDownButtons(context),
                    hvStarted
                        ? Container()
                        : Text(
                            "Must be more than 10 seconds~",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                  ],
                ),
              ],
            ));
  }

  _countDownButtons(BuildContext context) {
    return Column(
      children: [
        hvStarted
            ? _startedDisplay(context)
            : duration.inSeconds >= 10
                ? firebaseButton(context, "Start", () => startTimer())
                : firebaseButton(context, "Start!", () {}),
      ],
    );
  }

  _startedDisplay(context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          duration.inSeconds != 0
              ? firebaseButton(
                  context,
                  'Cancel',
                  () {
                    showDialog(
                        context: context, builder: (_) => _cancelTaskDialog());
                    timer!.cancel();
                  },
                )
              : firebaseButton(
                  context,
                  'Done',
                  () {
                    showDialog(
                        context: context,
                        builder: (_) => _completeTaskDialog(context));
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
                  startTimer();
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

  _completeTaskDialog(context) {
    List totalTime = CountDownHelper().timeString(initialDur.inSeconds);
    int moneyEarned = int.parse(totalTime[1]) + int.parse(totalTime[0]) * 60;
    print(moneyEarned);
    DatabaseService().addMoney(moneyEarned);
    fishMoney += moneyEarned;
    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      title: const Text("Congrats! You have earned"),
      content: SizedBox(
        height: size.height * 0.035,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/money.png',
                  height: size.height * 0.035,
                ),
                SizedBox(width: size.width * 0.02),
                Text(
                  '$moneyEarned',
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              stopTimer(true);
              widget._updateHomeScreen(fishMoney);
            });
            Navigator.pop(context);
          },
          child: Text("Back"),
        ),
      ],
    );
  }

  buildTimeCard(String time, String title, Size size) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.02),
          decoration: BoxDecoration(
            color: Color.fromARGB(172, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: hvStarted ? size.height * 0.1 : size.height * 0.065,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
