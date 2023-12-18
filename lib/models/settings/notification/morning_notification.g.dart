// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'morning_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MorningNotificationAdapter extends TypeAdapter<MorningNotification> {
  @override
  final int typeId = 4;

  @override
  MorningNotification read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MorningNotification.off;
      case 1:
        return MorningNotification.seven;
      case 2:
        return MorningNotification.eight;
      case 3:
        return MorningNotification.nine;
      case 4:
        return MorningNotification.ten;
      default:
        return MorningNotification.off;
    }
  }

  @override
  void write(BinaryWriter writer, MorningNotification obj) {
    switch (obj) {
      case MorningNotification.off:
        writer.writeByte(0);
        break;
      case MorningNotification.seven:
        writer.writeByte(1);
        break;
      case MorningNotification.eight:
        writer.writeByte(2);
        break;
      case MorningNotification.nine:
        writer.writeByte(3);
        break;
      case MorningNotification.ten:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MorningNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
