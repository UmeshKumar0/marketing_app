// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RemindersAdapter extends TypeAdapter<Reminders> {
  @override
  final int typeId = 23;

  @override
  Reminders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminders(
      sId: fields[0] as String?,
      emp: fields[1] as ReminderEmp?,
      visit: fields[2] as ReminderVisit?,
      shop: fields[3] as ReminderShop?,
      remarks: fields[4] as String?,
      date: fields[5] as String?,
      status: fields[6] as String?,
      uploaded: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Reminders obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.emp)
      ..writeByte(2)
      ..write(obj.visit)
      ..writeByte(3)
      ..write(obj.shop)
      ..writeByte(4)
      ..write(obj.remarks)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.uploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemindersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderEmpAdapter extends TypeAdapter<ReminderEmp> {
  @override
  final int typeId = 24;

  @override
  ReminderEmp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderEmp(
      sId: fields[0] as String?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderEmp obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderEmpAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderVisitAdapter extends TypeAdapter<ReminderVisit> {
  @override
  final int typeId = 25;

  @override
  ReminderVisit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderVisit(
      sId: fields[0] as String?,
      reason: fields[1] as String?,
      type: fields[2] as String?,
      remarks: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderVisit obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.reason)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.remarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderVisitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderShopAdapter extends TypeAdapter<ReminderShop> {
  @override
  final int typeId = 26;

  @override
  ReminderShop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderShop(
      sId: fields[0] as String?,
      name: fields[1] as String?,
      phone: fields[2] as String?,
      address: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderShop obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderShopAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
