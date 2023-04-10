// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitTypeAdapter extends TypeAdapter<VisitType> {
  @override
  final int typeId = 31;

  @override
  VisitType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitType(
      sId: fields[0] as String?,
      value: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
