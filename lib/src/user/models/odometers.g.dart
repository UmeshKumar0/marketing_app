// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odometers.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OdometersAdapter extends TypeAdapter<Odometers> {
  @override
  final int typeId = 7;

  @override
  Odometers read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Odometers(
      startCoordinate: fields[0] as StartCoordinate?,
      endCoordinate: fields[1] as StartCoordinate?,
      sId: fields[2] as String?,
      user: fields[3] as OdoMeterUser?,
      startReading: fields[4] as int?,
      createdAt: fields[5] as String?,
      updatedAt: fields[6] as String?,
      startReadingImage: fields[7] as String?,
      startReadingImageThumbnail: fields[8] as String?,
      endReading: fields[9] as int?,
      endReadingImage: fields[10] as String?,
      endReadingImageThumbnail: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Odometers obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.startCoordinate)
      ..writeByte(1)
      ..write(obj.endCoordinate)
      ..writeByte(2)
      ..write(obj.sId)
      ..writeByte(3)
      ..write(obj.user)
      ..writeByte(4)
      ..write(obj.startReading)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.startReadingImage)
      ..writeByte(8)
      ..write(obj.startReadingImageThumbnail)
      ..writeByte(9)
      ..write(obj.endReading)
      ..writeByte(10)
      ..write(obj.endReadingImage)
      ..writeByte(11)
      ..write(obj.endReadingImageThumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OdometersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StartCoordinateAdapter extends TypeAdapter<StartCoordinate> {
  @override
  final int typeId = 8;

  @override
  StartCoordinate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StartCoordinate(
      longitude: fields[0] as double?,
      latitude: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, StartCoordinate obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.longitude)
      ..writeByte(1)
      ..write(obj.latitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartCoordinateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OdoMeterUserAdapter extends TypeAdapter<OdoMeterUser> {
  @override
  final int typeId = 9;

  @override
  OdoMeterUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OdoMeterUser(
      sId: fields[0] as String?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OdoMeterUser obj) {
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
      other is OdoMeterUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
