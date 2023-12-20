// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'precipitation_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrecipitationUnitAdapter extends TypeAdapter<PrecipitationUnit> {
  @override
  final int typeId = 13;

  @override
  PrecipitationUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PrecipitationUnit.millimeters;
      case 1:
        return PrecipitationUnit.inches;
      default:
        return PrecipitationUnit.millimeters;
    }
  }

  @override
  void write(BinaryWriter writer, PrecipitationUnit obj) {
    switch (obj) {
      case PrecipitationUnit.millimeters:
        writer.writeByte(0);
        break;
      case PrecipitationUnit.inches:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrecipitationUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
