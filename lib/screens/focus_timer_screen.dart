import 'package:flutter/material.dart';

class FocusTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Focus Timer'),
      ),
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
        const SafeArea(child: Text('Focus Timer',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        ),
      ]
      ),
    );
  }
}
