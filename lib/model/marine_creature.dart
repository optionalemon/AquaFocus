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
  MarineCreatures(id: 1, image: "assets/images/Clownfish.png", type: "Clownfish", price: 0, description: "'Nemo', though filmed to alert human beings of the damage caused by trafficking us, has increased the number of us in tanks. An excellent example would be me.", color: Color.fromARGB(255, 180, 116, 86)),
  MarineCreatures(id: 2, image: "assets/images/Jellyfish.png", type: "Jellyfish", price: 180, description: "a Mangrove Box Jellyfish that caught between roots of a mangrove tree when a large area of mangrove forests was removed for urbanisation. ", color: Color.fromARGB(255, 102, 138, 160)),
];
