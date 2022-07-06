import 'package:AquaFocus/screens/FocusTimer/focus_timer_screen.dart';
import 'package:flutter/material.dart';

class FocusTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.cyan.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: const Icon(
              Icons.access_alarm,
              color: Colors.white,
              size: 38,
            ),
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.01),
          const Text(
            'Focus Timer',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.01),
          const Text(
            'Start focusing!',
            style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            )
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.03),
          ElevatedButton(
            onPressed: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FocusTimerScreen())
            );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue.withOpacity(0.5),
              onPrimary: Colors.white,
              shadowColor: Colors.blueAccent,
              elevation: 3,
                padding: EdgeInsets.all(15),
                shape: CircleBorder()),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          )
        ]
      )
    );
  }
}
