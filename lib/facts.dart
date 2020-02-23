import 'dart:ui';

class Fact {
  String factText;
  Color factColor;

  Fact(this.factText, this.factColor);

  Map<String, dynamic> toJson() =>
      {'factText': factText, 'factColor': factColor};

  Fact.fromJson(Map<String, dynamic> json)
      : factText = json['factText'],
        factColor = json['factColor'];
}
