import 'package:flutter/material.dart';

class AddBoardPage extends StatefulWidget {
  const AddBoardPage({Key? key}) : super(key: key);

  @override
  State<AddBoardPage> createState() => _AddBoardPageState();
}

class _AddBoardPageState extends State<AddBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Add a habit'),
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
    Text('Add a habit')
    ]
    )
    );
  }
}
