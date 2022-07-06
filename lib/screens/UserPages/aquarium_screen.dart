import 'package:flutter/material.dart';

class AquariumScreen extends StatefulWidget {
  @override
  State<AquariumScreen> createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Aquarium"),
        backgroundColor: Color.fromARGB(40, 0, 0, 0),
      ),
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background2.png'),
              fit: BoxFit.cover,
            ),
          ),)
    );
  }
}
