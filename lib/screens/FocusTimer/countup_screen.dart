import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_buttons.dart';
import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_helper.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CountUpScreen extends StatefulWidget {
  @override
  State<CountUpScreen> createState() => _CountUpScreenState();
}

class _CountUpScreenState extends State<CountUpScreen> {
  Duration duration = Duration(seconds: 0);
  Timer? timer;
  bool hvStarted = false;

  @override
  void initState() {
    super.initState();
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
          height: screenSize.height * 0.35,
            ),
            SizedBox(height: screenSize.height * 0.05),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildTimeCard(currTimeStr[0], 'HOURS',screenSize),
          SizedBox(width: screenSize.width * 0.02),
          buildTimeCard(currTimeStr[1], 'MINUTES',screenSize),
              SizedBox(width: screenSize.width * 0.02),
          buildTimeCard(currTimeStr[2], 'SECONDS',screenSize)
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
        SizedBox( height: size.height * 0.02),
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
            text: duration.inSeconds >= 10 ? 'Done' : 'Cancel', 
            press: () {
              showDialog(
                  context: context,
                  builder: (_) => duration.inSeconds >= 10
                      ? _completeTaskDialog()
                      : _cancelTaskDialog());
            },
          )
        ]);
  }

  _completeTaskDialog() {
    return AlertDialog(
      title: const Text("Congrats!"),
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
}
