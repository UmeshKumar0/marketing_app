// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingModelAdapter extends TypeAdapter<MeetingModel> {
  @override
  final int typeId = 61;

  @override
  MeetingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingModel(
      sId: fields[0] as String?,
      user: fields[1] as String?,
      date: fields[2] as int?,
      shop: fields[3] as MeetingShop?,
      strength: fields[4] as int?,
      food: fields[5] as String?,
      remarks: fields[6] as String?,
      gift: fields[7] as String?,
      status: fields[8] as String?,
      gallery: (fields[9] as List?)?.cast<String>(),
      requestedUser: fields[10] as String?,
      syncId: fields[11] as String?,
      synced: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.shop)
      ..writeByte(4)
      ..write(obj.strength)
      ..writeByte(5)
      ..write(obj.food)
      ..writeByte(6)
      ..write(obj.remarks)
      ..writeByte(7)
      ..write(obj.gift)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.gallery)
      ..writeByte(10)
      ..write(obj.requestedUser)
      ..writeByte(11)
      ..write(obj.syncId)
      ..writeByte(12)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeetingShopAdapter extends TypeAdapter<MeetingShop> {
  @override
  final int typeId = 62;

  @override
  MeetingShop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingShop(
      sId: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      phone: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingShop obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingShopAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
