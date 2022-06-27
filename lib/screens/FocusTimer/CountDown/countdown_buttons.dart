import 'package:flutter/material.dart';

class CountDownButtons extends StatelessWidget {
  final String text;
  final press;
  const CountDownButtons({
    required this.text,
    required this.press,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(MediaQuery.of(context).size.width * 0.024 * 3.6), 
              side: BorderSide(color: Colors.white))),
      onPressed: press,
      child: Text(text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          )),
    );
  }
}