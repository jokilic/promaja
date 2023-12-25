// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promaja_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromajaLogAdapter extends TypeAdapter<PromajaLog> {
  @override
  final int typeId = 15;

  @override
  PromajaLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromajaLog(
      text: fields[0] as String,
      time: fields[1] as DateTime,
      logLevel: fields[2] as PromajaLogLevel,
      isError: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PromajaLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.logLevel)
      ..writeByte(3)
      ..write(obj.isError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromajaLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
