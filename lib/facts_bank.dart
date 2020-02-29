import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:random_color/random_color.dart';
import 'package:random_facts/facts.dart';

class FactsBank {
  static Box displayBox = Hive.box('display');

  static Color getRandomColor() {
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(
        colorSaturation: ColorSaturation.lowSaturation);
    return _color;
  }

  static addBox() {
//    displayBox.clear();
    displayBox.addAll(factList);
    print('length ${displayBox.length}');
  }

  static List<Fact> factList = [
    Fact('At birth, a baby panda is smaller than a mouse.',
        getRandomColor().value),
    Fact('The only letter that doesn’t appear on the periodic table is J',
        getRandomColor().value),
    Fact('Sunflowers can help clean radioactive soil.', getRandomColor().value),
  ];
}
