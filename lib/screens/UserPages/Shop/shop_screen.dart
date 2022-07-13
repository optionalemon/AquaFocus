import 'package:AquaFocus/model/marine_creature.dart';
import 'package:AquaFocus/reusable_widgets/loading.dart';
import 'package:AquaFocus/screens/UserPages/Shop/details_screen.dart';
import 'package:AquaFocus/screens/UserPages/Shop/item_card.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopScreen extends StatefulWidget {
  final Function _updateHomeScreen;
  ShopScreen(this._updateHomeScreen);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int fishMoney = 0;
  bool loading = true;
  List marLives = [];

  void _update(
    int newLife,
    int cost,
  ) {
    setState(() {
      marLives.add(newLife);
      fishMoney = fishMoney - cost;
      widget._updateHomeScreen(fishMoney);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? const Loading()
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text("Shop"),
              backgroundColor: Color.fromARGB(40, 0, 0, 0),
              actions: [
                Container(
                    padding: EdgeInsets.all(size.width * 0.02),
                    margin: EdgeInsets.only(
                      right: size.width * 0.05,
                      top: size.height * 0.01,
                      bottom: size.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(children: <Widget>[
                      Image.asset(
                        'assets/icons/money.png',
                        height: size.height * 0.035,
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        '$fishMoney',
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
                    height: size.height * 0.05,
                  ),
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    child: GridView.builder(
                        itemCount: marinesCreatures.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: size.width * 0.03,
                            crossAxisSpacing: size.height * 0.03,
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
                                            updateShopState: _update,
                                          ))),
                            )),
                  ))
                ],
              ))
            ]));
  }
}
