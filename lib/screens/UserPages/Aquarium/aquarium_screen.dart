import 'package:AquaFocus/model/marine_creature.dart';
import 'package:AquaFocus/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AquariumScreen extends StatefulWidget {
  @override
  State<AquariumScreen> createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> {
  bool loading = true;
  List marLives = [];
  List<String> aqList = [];

  Future<void> getMarLives() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      marLives = await DatabaseServices().getMarLivesList(user.uid);
      for (int i = 0; i < marLives.length; i++) {
        for (int j = 0; j < marinesCreatures.length; j++) {
          if (marLives[i] == j) {
            aqList.add(marinesCreatures[j].image);
          }
        }

      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getMarLives();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text("Aquarium"),
              centerTitle: true,
              backgroundColor: Color.fromARGB(40, 0, 0, 0),
            ),
            body: Stack(children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/aquarium_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: buildAqCard(aqList),
              )
            ]));
  }

  buildAqCard(List<String> aqList) {
    Size size = MediaQuery.of(context).size;
    return ListWheelScrollView(
        itemExtent: 250,
        children: aqList
            .map(
              (e) => SizedBox(
                  width: size.width * 0.8,
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.06),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0.0, 5))
                        ]),
                    child: SizedBox(child: Image.asset(e)),
                  )),
            )
            .toList());
  }
}
