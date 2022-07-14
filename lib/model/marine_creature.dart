import 'package:flutter/material.dart';

class MarineCreatures {
  final String image, type, description;
  final int price, id;
  final Color color;

  MarineCreatures({
    required this.id,
    required this.image,
    required this.type,
    required this.price,
    required this.description,
    required this.color,
  });
}

List<MarineCreatures> marinesCreatures = [
  MarineCreatures(id: 0, image: "assets/images/Clownfish.png", type: "Clownfish", price: 0, description: "'Nemo', though filmed to alert human beings of the damage caused by trafficking us, has increased the number of us in tanks. An excellent example would be me.", color: Color.fromARGB(255, 180, 116, 86)),
  MarineCreatures(id: 1, image: "assets/images/Jellyfish.png", type: "Jellyfish", price: 180, description: "a Mangrove Box Jellyfish that saved between roots of a mangrove tree when a large area of mangrove forests was removed for urbanisation. ", color: Color.fromARGB(255, 102, 138, 160)),
  MarineCreatures(id: 2, image: "assets/images/whale.png", type: "Orca", price: 300, description: "Largest member of the dolphin family found in all oceans.", color: Color.fromARGB(255, 70, 70, 70)),
  MarineCreatures(id: 3, image: "assets/images/Turtle.png", type: "Turtle", price: 600, description: "a Madagascar big-headed turtle found outside protected areas.", color: Color.fromARGB(255, 76, 175, 116)),
  MarineCreatures(id: 4, image: "assets/images/SeaShell.png", type: "Oyster", price: 900, description: "Many of you may think that I am a seashell but seashell is just my portable homes. It is me, the oyster, that makes pearls.", color: Color.fromARGB(255, 127, 134, 211)),
  MarineCreatures(id: 5, image: "assets/images/axolotl.png", type: "Axolotl", price: 1200, description: "Usually found in Mexico freshwater lakes and ponds, critically endangered due to urbanisation and water pollution in Mexico.", color: Color.fromARGB(255, 236, 143, 147)),
  MarineCreatures(id: 6, image: "assets/images/MantaRay.png", type: "Manta Ray", price: 1800, description: "I may look hazardous but I only have 300 tiny teeth that cannot penetrate human skin.", color: Color.fromARGB(255, 162, 162, 162)),
];
