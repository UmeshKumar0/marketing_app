// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LatLon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LatLongAdapter extends TypeAdapter<LatLong> {
  @override
  final int typeId = 28;

  @override
  LatLong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatLong(
      longitude: fields[1] as double,
      latitude: fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LatLong obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
