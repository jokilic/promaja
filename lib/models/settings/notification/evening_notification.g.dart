// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evening_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EveningNotificationAdapter extends TypeAdapter<EveningNotification> {
  @override
  final int typeId = 5;

  @override
  EveningNotification read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EveningNotification.off;
      case 1:
        return EveningNotification.nineteen;
      case 2:
        return EveningNotification.twenty;
      case 3:
        return EveningNotification.twentyOne;
      case 4:
        return EveningNotification.twentyTwo;
      default:
        return EveningNotification.off;
    }
  }

  @override
  void write(BinaryWriter writer, EveningNotification obj) {
    switch (obj) {
      case EveningNotification.off:
        writer.writeByte(0);
        break;
      case EveningNotification.nineteen:
        writer.writeByte(1);
        break;
      case EveningNotification.twenty:
        writer.writeByte(2);
        break;
      case EveningNotification.twentyOne:
        writer.writeByte(3);
        break;
      case EveningNotification.twentyTwo:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EveningNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
