// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopsAdapter extends TypeAdapter<Shops> {
  @override
  final int typeId = 3;

  @override
  Shops read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Shops(
      sId: fields[0] as String?,
      name: fields[1] as String?,
      ownerName: fields[2] as String?,
      location: fields[3] as Locations?,
      email: fields[4] as String?,
      phone: fields[5] as String?,
      address: fields[6] as String?,
      pincode: fields[7] as String?,
      mapAddress: fields[8] as String?,
      status: fields[9] as String?,
      profile: fields[10] as Profile?,
      uploaded: fields[11] as bool,
      syncId: fields[12] as String?,
      createdAt: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Shops obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ownerName)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.pincode)
      ..writeByte(8)
      ..write(obj.mapAddress)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.profile)
      ..writeByte(11)
      ..write(obj.uploaded)
      ..writeByte(12)
      ..write(obj.syncId)
      ..writeByte(13)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationsAdapter extends TypeAdapter<Locations> {
  @override
  final int typeId = 4;

  @override
  Locations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Locations(
      type: fields[0] as String?,
      coordinates: (fields[1] as List?)?.cast<double>(),
      sId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Locations obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.coordinates)
      ..writeByte(2)
      ..write(obj.sId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 5;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      thumbnail: fields[0] as String?,
      url: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.thumbnail)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
