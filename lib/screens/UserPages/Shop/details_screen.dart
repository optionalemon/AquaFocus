import 'package:AquaFocus/model/marine_creature.dart';
import 'package:AquaFocus/screens/UserPages/Shop/shop_screen.dart';
import 'package:AquaFocus/screens/home_screen.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.marLife}) : super(key: key);
  final MarineCreatures marLife;

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
      ),
    );
  }
}

class DetailsBody extends StatelessWidget {
  final MarineCreatures marLife;
  const DetailsBody({Key? key, required this.marLife}) : super(key: key);

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
                    top: size.height * 0.12, left: 20, right: 20),
                height: 500,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    )),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      marLife.description,
                      style: TextStyle(height: 2.0, fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                            child: const Text(
                              "BUY NOW",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              showAlertDialog(context);
                            }, //TODO - user bought this fish, this is in user data, next time it will be shown as owned and unclickable
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marLife.type,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Price: ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/icons/money.png",
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("${marLife.price}",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 20,
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

      showAlertDialog(BuildContext context) {
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
        title: const Text("You have purchased successfully!",textAlign: TextAlign.center,),
        content: SizedBox(
          height: 125,
          child: Column(
            children: [
            Image.asset(marLife.image,width:100,height: 100),
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
