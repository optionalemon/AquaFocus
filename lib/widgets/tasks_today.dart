import 'package:AquaFocus/screens/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
      ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.01),
              const Text(
                  "Today's Tasks",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.01),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white70.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white
                    ),
                    Text(
                        " " + DateFormat.yMMMEd().format(DateTime.now()) + " ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )
                    ),
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white
                    ),
                  ],
                ),
              ),
              SizedBox( height: MediaQuery.of(context).size.height * 0.01),
              const Text(
                  "Take a look at today's agenda!",
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
                    MaterialPageRoute(builder: (context) => TaskScreen())
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
              ),
            ]
        )
    );
  }
}
