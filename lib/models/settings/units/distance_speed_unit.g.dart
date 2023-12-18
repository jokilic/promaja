// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distance_speed_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DistanceSpeedUnitAdapter extends TypeAdapter<DistanceSpeedUnit> {
  @override
  final int typeId = 9;

  @override
  DistanceSpeedUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DistanceSpeedUnit.kilometers;
      case 1:
        return DistanceSpeedUnit.miles;
      default:
        return DistanceSpeedUnit.kilometers;
    }
  }

  @override
  void write(BinaryWriter writer, DistanceSpeedUnit obj) {
    switch (obj) {
      case DistanceSpeedUnit.kilometers:
        writer.writeByte(0);
        break;
      case DistanceSpeedUnit.miles:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistanceSpeedUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
