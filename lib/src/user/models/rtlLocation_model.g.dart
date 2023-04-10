// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtlLocation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RTLocationAdapter extends TypeAdapter<RTLocation> {
  @override
  final int typeId = 87;

  @override
  RTLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RTLocation(
      userId: fields[0] as String,
      lat: fields[1] as double,
      lng: fields[2] as double,
    )..time = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, RTLocation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.lng)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RTLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
