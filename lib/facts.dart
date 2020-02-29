import 'package:hive/hive.dart';

part 'facts.g.dart';

@HiveType(typeId: 0)
class Fact {
  @HiveField(0)
  final String factText;
  @HiveField(1)
  final int factColor;

  Fact(this.factText, this.factColor);

  @override
  bool operator ==(other) => other is Fact && other.factText == factText;

  @override
  int get hashCode => factText.hashCode;

//  Fact.fromJson(Map<String, dynamic> json)
//      : factText = json['factText'],
//        factColor = json['factColor'];
//
//  Map<String, dynamic> toJson() =>
//      {'factText': factText, 'factColor': factColor};
}
