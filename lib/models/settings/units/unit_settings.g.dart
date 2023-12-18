// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitSettingsAdapter extends TypeAdapter<UnitSettings> {
  @override
  final int typeId = 8;

  @override
  UnitSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitSettings(
      temperature: fields[0] as TemperatureUnit,
      distanceSpeed: fields[1] as DistanceSpeedUnit,
      pressure: fields[2] as PressureUnit,
    );
  }

  @override
  void write(BinaryWriter writer, UnitSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.temperature)
      ..writeByte(1)
      ..write(obj.distanceSpeed)
      ..writeByte(2)
      ..write(obj.pressure);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
