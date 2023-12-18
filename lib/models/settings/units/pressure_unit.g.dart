// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pressure_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PressureUnitAdapter extends TypeAdapter<PressureUnit> {
  @override
  final int typeId = 10;

  @override
  PressureUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PressureUnit.hectopascal;
      case 1:
        return PressureUnit.inchesOfMercury;
      default:
        return PressureUnit.hectopascal;
    }
  }

  @override
  void write(BinaryWriter writer, PressureUnit obj) {
    switch (obj) {
      case PressureUnit.hectopascal:
        writer.writeByte(0);
        break;
      case PressureUnit.inchesOfMercury:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PressureUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
