// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promaja_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromajaSettingsAdapter extends TypeAdapter<PromajaSettings> {
  @override
  final typeId = 12;

  @override
  PromajaSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromajaSettings(
      notification: fields[0] as NotificationSettings,
      widget: fields[1] as WidgetSettings,
      unit: fields[2] as UnitSettings,
      appearance: fields[3] as AppearanceSettings,
    );
  }

  @override
  void write(BinaryWriter writer, PromajaSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.notification)
      ..writeByte(1)
      ..write(obj.widget)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.appearance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromajaSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
