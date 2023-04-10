// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_visit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreateVisitAdapter extends TypeAdapter<CreateVisit> {
  @override
  final int typeId = 32;

  @override
  CreateVisit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreateVisit(
      shop: fields[1] as String?,
      reason: fields[2] as String?,
      type: fields[3] as String,
      remarks: fields[6] as String,
      phone: fields[4] as String?,
      name: fields[5] as String?,
      time: fields[7] as String?,
      shopUploaded: fields[10] as bool,
      latitude: fields[8] as String?,
      longitude: fields[9] as String?,
      image: (fields[11] as List).cast<dynamic>(),
      withOutShop: fields[12] as bool,
      syncId: fields[13] as String?,
      createReminder: fields[14] as CreateReminder?,
    );
  }

  @override
  void write(BinaryWriter writer, CreateVisit obj) {
    writer
      ..writeByte(14)
      ..writeByte(1)
      ..write(obj.shop)
      ..writeByte(2)
      ..write(obj.reason)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.remarks)
      ..writeByte(7)
      ..write(obj.time)
      ..writeByte(8)
      ..write(obj.latitude)
      ..writeByte(9)
      ..write(obj.longitude)
      ..writeByte(10)
      ..write(obj.shopUploaded)
      ..writeByte(11)
      ..write(obj.image)
      ..writeByte(12)
      ..write(obj.withOutShop)
      ..writeByte(13)
      ..write(obj.syncId)
      ..writeByte(14)
      ..write(obj.createReminder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateVisitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
