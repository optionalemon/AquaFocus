import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        Center(
          child: CircularProgressIndicator(),
        )
      ]
    )
    );
  }
}
