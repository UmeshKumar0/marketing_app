// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserNotificationAdapter extends TypeAdapter<UserNotification> {
  @override
  final int typeId = 22;

  @override
  UserNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserNotification(
      sId: fields[0] as String?,
      userId: fields[1] as String?,
      title: fields[2] as String?,
      message: fields[3] as String?,
      type: fields[4] as String?,
      payload: fields[5] as String?,
      args: fields[6] as String?,
      date: fields[7] as String?,
      sended: fields[8] as bool?,
      read: fields[9] as bool?,
      iV: fields[10] as int?,
      createdAt: fields[11] as String?,
      updatedAt: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserNotification obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.payload)
      ..writeByte(6)
      ..write(obj.args)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.sended)
      ..writeByte(9)
      ..write(obj.read)
      ..writeByte(10)
      ..write(obj.iV)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
