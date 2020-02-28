import 'package:hive/hive.dart';

part 'questions.g.dart';

@HiveType(typeId: 1)
class Questions {
  @HiveField(0)
  String name;
  @HiveField(1)
  String age;

  Questions(this.name, this.age);
}
