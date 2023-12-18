// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingsAdapter extends TypeAdapter<NotificationSettings> {
  @override
  final int typeId = 3;

  @override
  NotificationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSettings(
      location: fields[0] as Location?,
      hourlyNotification: fields[1] as bool,
      morningNotification: fields[2] as MorningNotification,
      eveningNotification: fields[3] as EveningNotification,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.location)
      ..writeByte(1)
      ..write(obj.hourlyNotification)
      ..writeByte(2)
      ..write(obj.morningNotification)
      ..writeByte(3)
      ..write(obj.eveningNotification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
