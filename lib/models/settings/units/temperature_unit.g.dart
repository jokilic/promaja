// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temperature_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemperatureUnitAdapter extends TypeAdapter<TemperatureUnit> {
  @override
  final int typeId = 11;

  @override
  TemperatureUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TemperatureUnit.celsius;
      case 1:
        return TemperatureUnit.fahrenheit;
      default:
        return TemperatureUnit.celsius;
    }
  }

  @override
  void write(BinaryWriter writer, TemperatureUnit obj) {
    switch (obj) {
      case TemperatureUnit.celsius:
        writer.writeByte(0);
        break;
      case TemperatureUnit.fahrenheit:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemperatureUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
