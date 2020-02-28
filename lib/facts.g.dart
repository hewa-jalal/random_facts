// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facts.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FactAdapter extends TypeAdapter<Fact> {
  @override
  final typeId = 0;

  @override
  Fact read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fact(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Fact obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.factText)
      ..writeByte(1)
      ..write(obj.factColor);
  }
}
