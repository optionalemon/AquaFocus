import 'package:AquaFocus/model/marine_creature.dart';
import 'package:AquaFocus/screens/UserPages/Shop/categories.dart';
import 'package:AquaFocus/screens/UserPages/Shop/details_screen.dart';
import 'package:AquaFocus/screens/UserPages/Shop/item_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Shop"),
          backgroundColor: Color.fromARGB(40, 0, 0, 0),
        ),
        body: Stack(children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
              child: Column(
            children: [
              Categories(),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                        itemCount: marinesCreatures.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, 
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.75),
                        itemBuilder: (context, index) => ItemCard(
                              marLife: marinesCreatures[index], 
                              press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(marLife: marinesCreatures[index],))),
                            )),
                  ))
            ],
          ))
        ]));
  }
}


