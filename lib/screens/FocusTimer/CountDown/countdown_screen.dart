import 'package:AquaFocus/main.dart';
import 'package:AquaFocus/widgets/loading.dart';
import 'package:AquaFocus/widgets/reusable_widget.dart';
import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_helper.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CountDownScreen extends StatefulWidget {
  final Function _updateHomeScreen;
  bool hvStarted;
  final Function updateStart;
  CountDownScreen(this._updateHomeScreen, this.hvStarted, this.updateStart);

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  Duration duration = Duration(seconds: 1500);
  Duration initialDur = Duration(seconds: 1500);
  DateTime? startTime;
  DateTime? endTime;
  Timer? timer;
  int fishMoney = 0;
  bool loading = true;

  Future<void> getMarMoney() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fishMoney = await DatabaseServices().getMoney();
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    widget.hvStarted = true;
    widget.updateStart(true);
    timer?.cancel();
    initialDur = duration;
    timer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
    startTime = DateTime.now();
    endTime = startTime!.add(initialDur);
  }

  void stopTimer(bool isComplete) {
    widget.hvStarted = false;
    widget.updateStart(false);
    duration = initialDur;
    timer!.cancel();
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = duration.inSeconds - reduceSecondsBy;
      if (duration.inSeconds == 0 && widget.hvStarted) {
        notifyHelper.showNotification();
        showDialog(
            context: context, builder: (_) => _completeTaskDialog(context));
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
                    widget.hvStarted
                        ? SizedBox(height: size.height * 0.05)
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTimeCard(currTimeStr[0], 'HOURS', size),
                        widget.hvStarted
                            ? SizedBox(width: size.width * 0.02)
                            : SizedBox(
                                width: size.width * 0.1,
                                child: RotatedBox(
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
                              ),
                        buildTimeCard(currTimeStr[1], 'MINUTES', size),
                        widget.hvStarted
                            ? SizedBox(width: size.width * 0.02)
                            : SizedBox(
                                width: size.width * 0.1,
                                child: RotatedBox(
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
                              ),
                        buildTimeCard(currTimeStr[2], 'SECONDS', size),
                        widget.hvStarted
                            ? SizedBox(width: size.width * 0.02)
                            : SizedBox(
                                width: size.width * 0.1,
                                child: RotatedBox(
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
                              ),
                      ],
                    ),
                    _countDownButtons(context),
                    widget.hvStarted
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
        widget.hvStarted
            ? _startedDisplay(context)
            : duration.inSeconds >= 10
                ? firebaseButton(context, "Start", () => startTimer(), true)
                : firebaseButton(context, "Start!", () {}, true),
      ],
    );
  }

  _startedDisplay(context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          duration.inSeconds != 0
              ? firebaseButton(context, 'Cancel', () {
                  showDialog(
                      context: context, builder: (_) => _cancelTaskDialog());
                  timer!.cancel();
                }, true)
              : Container()
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
                },
                child: Text("Yes"),
              ),
            ],
          )
        ]);
  }

  _completeTaskDialog(context) {
    List totalTime = CountDownHelper().timeString(initialDur.inSeconds);
    int moneyEarned = int.parse(totalTime[2]) +
        int.parse(totalTime[1]) * 60 +
        int.parse(totalTime[0]) * 60;
    DatabaseServices().saveFocusTime(moneyEarned,
        DateFormat('yyyy-MM-dd').format(DateTime.now()), startTime!, endTime!);
    DatabaseServices().addMoney(moneyEarned);
    fishMoney += moneyEarned;
    Size size = MediaQuery.of(context).size;

    print('startTime:$startTime');
    print('endTime:$endTime');

    return AlertDialog(
      title: const Text("Congrats! You have earned"),
      content: Wrap(children: [
        Column(
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
      ]),
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
          width: widget.hvStarted ? size.width * 0.312 : size.width * 0.225,
          padding: EdgeInsets.all(size.width * 0.02),
          decoration: BoxDecoration(
            color: Color.fromARGB(172, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            time,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: widget.hvStarted ? size.height * 0.09 : size.height * 0.065,
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
