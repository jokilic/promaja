// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InitialSectionAdapter extends TypeAdapter<InitialSection> {
  @override
  final typeId = 17;

  @override
  InitialSection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InitialSection.lastOpened;
      case 1:
        return InitialSection.current;
      case 2:
        return InitialSection.forecast;
      case 3:
        return InitialSection.map;
      case 4:
        return InitialSection.list;
      case 5:
        return InitialSection.settings;
      default:
        return InitialSection.lastOpened;
    }
  }

  @override
  void write(BinaryWriter writer, InitialSection obj) {
    switch (obj) {
      case InitialSection.lastOpened:
        writer.writeByte(0);
      case InitialSection.current:
        writer.writeByte(1);
      case InitialSection.forecast:
        writer.writeByte(2);
      case InitialSection.map:
        writer.writeByte(3);
      case InitialSection.list:
        writer.writeByte(4);
      case InitialSection.settings:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InitialSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
