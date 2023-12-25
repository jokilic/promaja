// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promaja_log_level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromajaLogLevelAdapter extends TypeAdapter<PromajaLogLevel> {
  @override
  final int typeId = 16;

  @override
  PromajaLogLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PromajaLogLevel.info;
      case 1:
        return PromajaLogLevel.error;
      default:
        return PromajaLogLevel.info;
    }
  }

  @override
  void write(BinaryWriter writer, PromajaLogLevel obj) {
    switch (obj) {
      case PromajaLogLevel.info:
        writer.writeByte(0);
        break;
      case PromajaLogLevel.error:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromajaLogLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
