import 'package:AquaFocus/model/marine_creature.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final MarineCreatures marLife;
  final VoidCallback press;
  final bool isBought;

  const ItemCard({
    Key? key,
    required this.marLife,
    required this.press,
    required this.isBought,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.04),
                  decoration: BoxDecoration(
                    color: marLife.color.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset(marLife.image),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.025 / 4),
            child: Text(
              marLife.type,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          isBought
              ? Text("Owned", style: TextStyle(color: Colors.white))
              : Row(
                  children: [
                    Image.asset(
                      "assets/icons/money.png",
                      height: size.height * 0.025,
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    Text(marLife.price.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                )
        ],
      ),
    );
  }
}
