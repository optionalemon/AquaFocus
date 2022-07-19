import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  'assets/images/Onboarding1.png',
  'assets/images/Onboarding2.png',
  'assets/images/Onboarding3.png',
  'assets/images/Onboarding4.png',
  'assets/images/Onboarding5.png',
  'assets/images/Onboarding6.png',
];

class coreConcept extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget> [
          Scaffold(
            body: Builder(
              builder: (context) {
                final double height = MediaQuery.of(context).size.height;
                return CarouselSlider(
                  options: CarouselOptions(
                    height: height,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                  ),
                  items: imgList
                      .map((item) => Container(
                    constraints: const BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ))
                      .toList(),
                );
              },
            ),
          ),
          Positioned(
              bottom: 27,
              left: 27,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('          '),
              )
          ),
        ]
    );
  }
}