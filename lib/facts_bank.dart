import 'dart:ui';

import 'package:random_color/random_color.dart';
import 'package:random_facts/facts.dart';

class FactsBank {
  static Color getRandomColor() {
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(
        colorSaturation: ColorSaturation.lowSaturation);
    return _color;
  }

  static List<Fact> factList = [
    Fact('At birth, a baby panda is smaller than a mouse.', getRandomColor()),
    Fact('The only letter that doesn’t appear on the periodic table is J',
        getRandomColor()),
    Fact(
        'Sunflowers can help clean radioactive soil. Japan is using this to rehabilitate Fukashima. Almost 10,000 packets of sunflower seeds have been sold to the people of the city.',
        getRandomColor()),
  ];

  static List<Fact> favouriteFacts = [];

  void add(String text, Color color) {
    factList.add(Fact(text, color));
  }
}
