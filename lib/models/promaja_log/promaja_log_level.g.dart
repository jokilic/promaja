// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promaja_log_level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromajaLogGroupAdapter extends TypeAdapter<PromajaLogGroup> {
  @override
  final int typeId = 16;

  @override
  PromajaLogGroup read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PromajaLogGroup.initialization;
      case 1:
        return PromajaLogGroup.api;
      case 2:
        return PromajaLogGroup.currentWeather;
      case 3:
        return PromajaLogGroup.forecastWeather;
      case 4:
        return PromajaLogGroup.list;
      case 5:
        return PromajaLogGroup.settings;
      case 6:
        return PromajaLogGroup.notification;
      case 7:
        return PromajaLogGroup.widget;
      case 8:
        return PromajaLogGroup.location;
      case 9:
        return PromajaLogGroup.cardColor;
      case 10:
        return PromajaLogGroup.logging;
      case 11:
        return PromajaLogGroup.unit;
      case 12:
        return PromajaLogGroup.background;
      case 13:
        return PromajaLogGroup.navigation;
      default:
        return PromajaLogGroup.initialization;
    }
  }

  @override
  void write(BinaryWriter writer, PromajaLogGroup obj) {
    switch (obj) {
      case PromajaLogGroup.initialization:
        writer.writeByte(0);
        break;
      case PromajaLogGroup.api:
        writer.writeByte(1);
        break;
      case PromajaLogGroup.currentWeather:
        writer.writeByte(2);
        break;
      case PromajaLogGroup.forecastWeather:
        writer.writeByte(3);
        break;
      case PromajaLogGroup.list:
        writer.writeByte(4);
        break;
      case PromajaLogGroup.settings:
        writer.writeByte(5);
        break;
      case PromajaLogGroup.notification:
        writer.writeByte(6);
        break;
      case PromajaLogGroup.widget:
        writer.writeByte(7);
        break;
      case PromajaLogGroup.location:
        writer.writeByte(8);
        break;
      case PromajaLogGroup.cardColor:
        writer.writeByte(9);
        break;
      case PromajaLogGroup.logging:
        writer.writeByte(10);
        break;
      case PromajaLogGroup.unit:
        writer.writeByte(11);
        break;
      case PromajaLogGroup.background:
        writer.writeByte(12);
        break;
      case PromajaLogGroup.navigation:
        writer.writeByte(13);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromajaLogGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
