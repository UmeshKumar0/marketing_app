// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_odometer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreateOdometerModelAdapter extends TypeAdapter<CreateOdometerModel> {
  @override
  final int typeId = 27;

  @override
  CreateOdometerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreateOdometerModel(
      reading: fields[0] as String?,
      coordinate: fields[1] as LatLong?,
      imgPath: fields[2] as String?,
      completed: fields[3] as bool,
      isAbsent: fields[4] as bool,
      address: fields[5] as String?,
      time: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CreateOdometerModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.reading)
      ..writeByte(1)
      ..write(obj.coordinate)
      ..writeByte(2)
      ..write(obj.imgPath)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.isAbsent)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOdometerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
