// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherTypeAdapter extends TypeAdapter<WeatherType> {
  @override
  final int typeId = 7;

  @override
  WeatherType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeatherType.current;
      case 1:
        return WeatherType.forecast;
      default:
        return WeatherType.current;
    }
  }

  @override
  void write(BinaryWriter writer, WeatherType obj) {
    switch (obj) {
      case WeatherType.current:
        writer.writeByte(0);
      case WeatherType.forecast:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
