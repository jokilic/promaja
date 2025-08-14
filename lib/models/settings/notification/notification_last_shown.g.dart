// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_last_shown.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationLastShownAdapter extends TypeAdapter<NotificationLastShown> {
  @override
  final typeId = 14;

  @override
  NotificationLastShown read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationLastShown(
      morningNotificationLastShown: fields[0] as DateTime,
      eveningNotificationLastShown: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationLastShown obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.morningNotificationLastShown)
      ..writeByte(1)
      ..write(obj.eveningNotificationLastShown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationLastShownAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
