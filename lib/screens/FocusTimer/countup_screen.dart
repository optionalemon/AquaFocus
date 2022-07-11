import 'package:AquaFocus/reusable_widgets/reusable_widget.dart';
import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_helper.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CountUpScreen extends StatefulWidget {
  final Function _updateHomeScreen;
  CountUpScreen(this._updateHomeScreen);

  @override
  State<CountUpScreen> createState() => _CountUpScreenState();
}

class _CountUpScreenState extends State<CountUpScreen> {
  Duration duration = Duration(seconds: 0);
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
    timer = Timer.periodic(Duration(seconds: 1), (_) => setCountUp());
  }

  void setCountUp() {
    final addSecondsBy = 1;
    setState(() {
      final seconds = duration.inSeconds + addSecondsBy;
      duration = Duration(seconds: seconds);
    });
  }

  void stopTimer(bool isComplete) {
    hvStarted = false;
    duration = Duration(seconds: 0);
    timer!.cancel();
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
          Column(children: [
            SizedBox(height: screenSize.height * 0.05),
            Image.asset(
              'assets/images/hourglass.png',
              height: screenSize.height * 0.3,
            ),
            SizedBox(height: screenSize.height * 0.05),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildTimeCard(currTimeStr[0], 'HOURS', screenSize),
              SizedBox(width: screenSize.width * 0.02),
              buildTimeCard(currTimeStr[1], 'MINUTES', screenSize),
              SizedBox(width: screenSize.width * 0.02),
              buildTimeCard(currTimeStr[2], 'SECONDS', screenSize)
            ]),
            _countUpButtons(),
            hvStarted && duration.inSeconds < 10
                ? Text(
                    "Must be more than 10 seconds",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  )
                : Container(),
          ]),
        ],
      ),
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
              fontSize: size.height * 0.1,
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

  _countUpButtons() {
    return Column(
      children: [
        hvStarted
            ? _startedDisplay()
            : firebaseButton(context, "Start", () => startTimer()),
      ],
    );
  }

  _startedDisplay() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          firebaseButton(
            context,
            duration.inSeconds >= 10 ? 'Done' : 'Cancel',
            () {
              showDialog(
                  context: context,
                  builder: (_) => duration.inSeconds >= 10
                      ? _completeTaskDialog()
                      : _cancelTaskDialog());
              setState(() {
                timer!.cancel();
              });
            },
          )
        ]);
  }

  _completeTaskDialog() {
    List totalTime = CountDownHelper().timeString(duration.inSeconds);
    int moneyEarned = int.parse(totalTime[2]) + int.parse(totalTime[1])*60 + int.parse(totalTime[0]) * 60;
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
            Navigator.pop(context);
            setState(() {
              widget._updateHomeScreen(fishMoney);
              stopTimer(true);
            });
          },
          child: Text("Back"),
        ),
      ],
    );
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
                  startTimer();
                },
                child: Text("No"),
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
}
