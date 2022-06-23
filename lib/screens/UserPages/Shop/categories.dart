import 'package:flutter/material.dart';

//stateful widget for categories

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> oceans = ["Pacific", "Arctic", "Atlantic", "Southern", "Indian"];
  int selectedIndex = 0; //Default, first category selected

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: oceans.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text(
              oceans[index], 
              style: TextStyle(
                color: selectedIndex == index ? Colors.white: Color.fromARGB(255, 198, 198, 198),
                )),
            Container(
              margin: EdgeInsets.only(top: 20/5),
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.blue: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
