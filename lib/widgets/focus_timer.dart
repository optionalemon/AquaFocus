import 'package:AquaFocus/screens/FocusTimer/focus_timer_screen.dart';
import 'package:AquaFocus/screens/home_screen.dart';
import 'package:flutter/material.dart';

class FocusTimer extends StatelessWidget {
  const FocusTimer({Key? key,
      required this.updateHomeState,
      })
      : super(key: key);
      final updateHomeState;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(
            builder: (context) => FocusTimerScreen(updateHomeState)));
      },
      child: Container(
          margin: EdgeInsets.all(size.width * 0.04),
          padding: EdgeInsets.all(size.width * 0.05),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(size.width * 0.0125),
                  child: Icon(
                    Icons.access_alarm,
                    color: Colors.white,
                    size: size.height * 0.06,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text('Focus Timer',
                    style: TextStyle(
                      fontSize: size.height * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                SizedBox(height: size.height * 0.01),
                Text('Start focusing!',
                    style: TextStyle(
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    )),
                SizedBox(height: size.height * 0.03),
                
              ])),
    );
  }
}
