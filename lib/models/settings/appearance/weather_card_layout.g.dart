// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_card_layout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherCardLayoutAdapter extends TypeAdapter<WeatherCardLayout> {
  @override
  final typeId = 19;

  @override
  WeatherCardLayout read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeatherCardLayout.stacked;
      case 1:
        return WeatherCardLayout.carousel;
      default:
        return WeatherCardLayout.stacked;
    }
  }

  @override
  void write(BinaryWriter writer, WeatherCardLayout obj) {
    switch (obj) {
      case WeatherCardLayout.stacked:
        writer.writeByte(0);
      case WeatherCardLayout.carousel:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherCardLayoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
