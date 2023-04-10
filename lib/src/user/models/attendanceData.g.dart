// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendanceData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceDataAdapter extends TypeAdapter<AttendanceData> {
  @override
  final int typeId = 6;

  @override
  AttendanceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceData(
      data: (fields[0] as Map).cast<String, dynamic>(),
      distance: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.distance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
