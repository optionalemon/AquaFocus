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
    SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: double.infinity,
        decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [
                        Colors.cyan.withOpacity(0.5),
                        Colors.white.withOpacity(0.5)
                      ]),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0.0, 5))
                      ]),
        child: Column(children: [
          
        ]),
      ),
    ),
      ],
    );
  }
}
