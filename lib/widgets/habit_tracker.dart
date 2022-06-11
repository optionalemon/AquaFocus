import 'package:AquaFocus/screens/habit_tracker_screen.dart';
import 'package:flutter/material.dart';

class HabitTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: const Icon(
                  Icons.auto_graph,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(
                  height: 15
              ),
              const Text(
                  'Habit Tracker',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
              ),
              const SizedBox(
                  height: 15
              ),
              const Text(
                  'Build new habits!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  )
              ),
              const SizedBox(
                  height: 15
              ),
              ElevatedButton(
                onPressed: () { Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HabitTrackerScreen())
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
