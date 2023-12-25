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
        return PromajaLogLevel.api;
      case 2:
        return PromajaLogLevel.currentWeather;
      case 3:
        return PromajaLogLevel.forecastWeather;
      case 4:
        return PromajaLogLevel.list;
      case 5:
        return PromajaLogLevel.settings;
      case 6:
        return PromajaLogLevel.notification;
      case 7:
        return PromajaLogLevel.widget;
      case 8:
        return PromajaLogLevel.location;
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
      case PromajaLogLevel.api:
        writer.writeByte(1);
        break;
      case PromajaLogLevel.currentWeather:
        writer.writeByte(2);
        break;
      case PromajaLogLevel.forecastWeather:
        writer.writeByte(3);
        break;
      case PromajaLogLevel.list:
        writer.writeByte(4);
        break;
      case PromajaLogLevel.settings:
        writer.writeByte(5);
        break;
      case PromajaLogLevel.notification:
        writer.writeByte(6);
        break;
      case PromajaLogLevel.widget:
        writer.writeByte(7);
        break;
      case PromajaLogLevel.location:
        writer.writeByte(8);
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
