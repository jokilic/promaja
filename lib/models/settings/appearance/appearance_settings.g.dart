// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appearance_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppearanceSettingsAdapter extends TypeAdapter<AppearanceSettings> {
  @override
  final int typeId = 18;

  @override
  AppearanceSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppearanceSettings(
      initialSection: fields[0] as InitialSection,
    );
  }

  @override
  void write(BinaryWriter writer, AppearanceSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.initialSection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppearanceSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
