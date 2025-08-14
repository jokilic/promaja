// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WidgetSettingsAdapter extends TypeAdapter<WidgetSettings> {
  @override
  final typeId = 6;

  @override
  WidgetSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WidgetSettings(
      location: fields[0] as Location?,
      weatherType: fields[1] as WeatherType,
    );
  }

  @override
  void write(BinaryWriter writer, WidgetSettings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.location)
      ..writeByte(1)
      ..write(obj.weatherType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
