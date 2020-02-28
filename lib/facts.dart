import 'dart:ui';

import 'package:hive/hive.dart';

part 'facts.g.dart';

@HiveType(typeId: 0)
class Fact {
  @HiveField(0)
  String factText;
  @HiveField(1)
  int factColor;

  Fact(this.factText, this.factColor);

//  Fact.fromJson(Map<String, dynamic> json)
//      : factText = json['factText'],
//        factColor = json['factColor'];
//
//  Map<String, dynamic> toJson() =>
//      {'factText': factText, 'factColor': factColor};
}
