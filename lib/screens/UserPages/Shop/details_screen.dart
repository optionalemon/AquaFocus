import 'package:AquaFocus/model/marine_creature.dart';
import 'package:AquaFocus/screens/UserPages/Shop/shop_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AquaFocus/services/database_services.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen(
      {Key? key,
      required this.marLife,
      required this.isBought,
      required this.updateShopState})
      : super(key: key);
  final MarineCreatures marLife;
  final bool isBought;
  final updateShopState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: marLife.color,
      appBar: AppBar(
        backgroundColor: marLife.color,
        elevation: 0,
      ),
      body: DetailsBody(
        marLife: marLife,
        isBought: isBought,
        updateShopState: updateShopState,
      ),
    );
  }
}

class DetailsBody extends StatelessWidget {
  final MarineCreatures marLife;
  final bool isBought;
  final updateShopState;
  const DetailsBody(
      {Key? key,
      required this.marLife,
      required this.isBought,
      required this.updateShopState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: size.height * 0.3),
                padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: size.width * 0.05,
                    right: size.width * 0.05),
                height: size.height * 0.6,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    )),
                child: Column(children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.025),
                    child: Text(
                      marLife.description,
                      style: TextStyle(
                          height: size.height * 0.002,
                          fontSize: size.height * 0.022),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(marLife.color),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            child: isBought
                                ? Text(
                                    "OWNED",
                                    style: TextStyle(
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "BUY NOW",
                                    style: TextStyle(
                                      fontSize: size.height * 0.025,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                            onPressed: () {
                              isBought ? null : _purchase(context);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marLife.type,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    Row(
                      children: [
                        Text(
                          "Price: ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.025),
                        ),
                        SizedBox(
                          width: size.width * 0.025,
                        ),
                        Image.asset(
                          "assets/icons/money.png",
                          height: size.height * 0.035,
                        ),
                        SizedBox(
                          width: size.width * 0.025,
                        ),
                        Text("${marLife.price}",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Expanded(
                            child: Image.asset(
                          marLife.image,
                          fit: BoxFit.fitWidth,
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }

  _purchase(context) async {
    bool hasEnough = await DatabaseService().hasEnoughMoney(marLife.price);
    if (hasEnough) {
      updateShopState(marLife.id, marLife.price);
      DatabaseService().addMoney(-marLife.price);
      DatabaseService()
          .addMarLives(FirebaseAuth.instance.currentUser!.uid, marLife.id);

      showAlertDialog(context, "You have purchased successfully!");
    } else {
      showAlertDialog(context, "You don't have enough fish coin :(");
    }
  }

  showAlertDialog(BuildContext context, String message) {
    Size size = MediaQuery.of(context).size;
    // set up the buttons
    Widget okButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        message,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: size.height * 0.16,
        child: Column(children: [
          Image.asset(marLife.image, width: size.width*0.25, height: size.height*0.125),
          Text(marLife.type)
        ]),
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
