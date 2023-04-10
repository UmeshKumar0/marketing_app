// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopCreate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopCreateAdapter extends TypeAdapter<ShopCreate> {
  @override
  final int typeId = 29;

  @override
  ShopCreate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopCreate(
      name: fields[0] as String?,
      shopAddress: fields[4] as String?,
      shopBrand: fields[5] as String?,
      shopEmail: fields[2] as String?,
      shopOwner: fields[1] as String?,
      shopPhone: fields[3] as String?,
      shopPincode: fields[7] as String?,
      shopProducts: fields[6] as String?,
      locationModel: fields[8] as LocationModel?,
      mapAddress: fields[9] as String?,
      shopImg: (fields[10] as List?)?.cast<dynamic>(),
      time: fields[11] as String?,
      id: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShopCreate obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.shopOwner)
      ..writeByte(2)
      ..write(obj.shopEmail)
      ..writeByte(3)
      ..write(obj.shopPhone)
      ..writeByte(4)
      ..write(obj.shopAddress)
      ..writeByte(5)
      ..write(obj.shopBrand)
      ..writeByte(6)
      ..write(obj.shopProducts)
      ..writeByte(7)
      ..write(obj.shopPincode)
      ..writeByte(8)
      ..write(obj.locationModel)
      ..writeByte(9)
      ..write(obj.mapAddress)
      ..writeByte(10)
      ..write(obj.shopImg)
      ..writeByte(11)
      ..write(obj.time)
      ..writeByte(12)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopCreateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
