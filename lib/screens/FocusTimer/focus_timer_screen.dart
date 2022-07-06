import 'package:AquaFocus/screens/FocusTimer/CountDown/countdown_screen.dart';
import 'package:AquaFocus/screens/FocusTimer/countup_screen.dart';
import 'package:AquaFocus/screens/FocusTimer/lock_screen.dart';
import 'package:flutter/material.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({Key? key}) : super(key: key);

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  int currentIndex = 0;
  final screens = [CountDownScreen(), CountUpScreen(), ExamScreen()];
  final pressed = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Focus Timer'),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: _getNavBar(context),
    );
  }

//bottom navigation bar
  _getNavBar(context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: ClipPath(
            clipper: NavBarClipper(),
            child: Container(
              height: size.height * 0.075,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                    Color(0xA0FFFffF),
                    Color.fromARGB(159, 52, 121, 217),
                    Color.fromARGB(184, 10, 85, 155),
                    Color.fromARGB(184, 16, 54, 110),
                  ])),
            ),
          ),
        ),
        Positioned(
            bottom: size.height * 0.055,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildNavItem(Icons.access_time_filled, context, 0),
                SizedBox(width: size.width*0.0025),
                _buildNavItem(Icons.access_time, context, 1),
                SizedBox(width: size.width*0.0025),
                _buildNavItem(Icons.lock_clock, context, 2),
              ],
            )),
        Positioned(
            bottom: size.height * 0.0125,
            width: MediaQuery.of(context).size.width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  <Widget>[
                  Text("Countdown",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500)),
                  SizedBox(
                    width: size.width*0.005,
                  ),
                  Text("Count Up  ",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500)),
                  SizedBox(
                    width: size.width*0.025,
                  ),
                  Text("Lock Mode",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500)),
                ]))
      ],
    );
  }

  Widget _buildNavItem(IconData icon, BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Color.fromARGB(198, 76, 122, 170),
            shape: CircleBorder(),
          ),
          child: pressed[index]
              ? IconButton(
                  icon: Icon(icon, size: size.height * 0.037),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      currentIndex = index;
                      for (int i = 0; i < 3; i++) {
                        pressed[i] = false;
                      }
                      pressed[index] = true;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(icon),
                  color: Colors.blueAccent,
                  onPressed: () {
                    setState(() {
                      currentIndex = index;
                      for (int i = 0; i < 3; i++) {
                        pressed[i] = false;
                      }
                      pressed[index] = true;
                    });
                  },
                ),
        ),
      ),
    );
  }
}

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.cubicTo(sw / 12, 0, sw / 12, 2 * sh / 5, 2 * sw / 12, 2 * sh / 5);
    path.cubicTo(3 * sw / 12, 2 * sh / 5, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.cubicTo(
        9 * sw / 12, 0, 9 * sw / 12, 2 * sh / 5, 10 * sw / 12, 2 * sh / 5);
    path.cubicTo(11 * sw / 12, 2 * sh / 5, 11 * sw / 12, 0, sw, 0);

    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
