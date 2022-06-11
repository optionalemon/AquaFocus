import 'package:AquaFocus/assets/fish_icon_icons.dart';
import 'package:AquaFocus/services/firebase_services.dart';
import 'package:AquaFocus/widgets/focus_timer.dart';
import 'package:AquaFocus/widgets/habit_tracker.dart';
import 'package:AquaFocus/widgets/to_do_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/screens/signin_screen.dart';

import '../widgets/fun_fact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: Stack(children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ToDo(),
              Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: FocusTimer()),
                  Expanded(child: HabitTracker()),
                ]
              ),
            ),
              Row(
                  children: [
                    Expanded(child: FunFact())
                  ]
              )
            ],
          )
          )
        ]
        ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(children: [
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/icons/AquaFocus_icon.png')),
          ),
          const SizedBox(width: 10),
          const Text(
            'Hello :)',
            style: TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          )
        ]),
        actions: const [
          Icon(
            FishIcon.fish,
            color: Colors.white,
            size: 20,
          )
        ]);
  }
}
/*
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: () async {
            await FirebaseServices().signOut().then((value) {
              print("Signed out!");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },
        ),
      ),
    );
  }
}
*/
