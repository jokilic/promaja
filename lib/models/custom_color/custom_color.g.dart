// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_color.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomColorAdapter extends TypeAdapter<CustomColor> {
  @override
  final typeId = 2;

  @override
  CustomColor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomColor(
      code: (fields[1] as num).toInt(),
      isDay: fields[2] as bool,
      color: fields[3] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, CustomColor obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.isDay)
      ..writeByte(3)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
