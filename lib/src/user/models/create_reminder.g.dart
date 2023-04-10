// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreateReminderAdapter extends TypeAdapter<CreateReminder> {
  @override
  final int typeId = 35;

  @override
  CreateReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreateReminder(
      visit: fields[0] as String?,
      shop: fields[1] as String?,
      remarks: fields[2] as String?,
      date: fields[3] as String?,
      syncId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CreateReminder obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.visit)
      ..writeByte(1)
      ..write(obj.shop)
      ..writeByte(2)
      ..write(obj.remarks)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.syncId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
