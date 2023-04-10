// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingUserAdapter extends TypeAdapter<MeetingUser> {
  @override
  final int typeId = 45;

  @override
  MeetingUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingUser(
      profile: fields[0] as UserProfile?,
      sId: fields[1] as String?,
      name: fields[2] as String?,
      phone: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.profile)
      ..writeByte(1)
      ..write(obj.sId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 46;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      thumbnailUrl: fields[0] as String?,
      url: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.thumbnailUrl)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
