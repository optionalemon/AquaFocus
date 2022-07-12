import 'package:flutter/material.dart';

class ListBodyPage extends StatefulWidget {
  const ListBodyPage({Key? key}) : super(key: key);

  @override
  State<ListBodyPage> createState() => _ListBodyPageState();
}

class _ListBodyPageState extends State<ListBodyPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/mainscreen.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
      ],
    );
  }
}
