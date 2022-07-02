import 'package:AquaFocus/model/marine_creature.dart';
import 'package:AquaFocus/screens/UserPages/Shop/details_screen.dart';
import 'package:AquaFocus/screens/UserPages/Shop/item_card.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:AquaFocus/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopScreen extends StatefulWidget {
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int fishMoney = 0;
  bool loading = true;
  List marLives = [];

  Future<void> getMarMoney() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fishMoney = await DatabaseService().getMoney();
      marLives = await DatabaseService().getMarLivesList(user.uid);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getMarMoney();
    super.initState();
  }

  _updateState() {
    loading = true;
    getMarMoney();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text("Shop"),
              backgroundColor: Color.fromARGB(40, 0, 0, 0),
              actions: [
                Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(children: <Widget>[
                      Image.asset(
                        'assets/icons/money.png',
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '$fishMoney',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ])),
              ],
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
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
                              isBought: marLives.contains(index),
                              press: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                            marLife: marinesCreatures[index],
                                            isBought: marLives.contains(index),
                                            updateState: _updateState(),
                                          ))),
                            )),
                  ))
                ],
              ))
            ]));
  }
}
