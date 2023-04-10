// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teams_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTeamAdapter extends TypeAdapter<UserTeam> {
  @override
  final int typeId = 10;

  @override
  UserTeam read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserTeam(
      sId: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      visits: (fields[3] as List?)?.cast<TeamVisits>(),
      odometers: (fields[4] as List?)?.cast<TeamOdometers>(),
      lastActive: fields[5] as LastActive?,
      profile: fields[6] as TeamProfile?,
    );
  }

  @override
  void write(BinaryWriter writer, UserTeam obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.visits)
      ..writeByte(4)
      ..write(obj.odometers)
      ..writeByte(5)
      ..write(obj.lastActive)
      ..writeByte(6)
      ..write(obj.profile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamVisitsAdapter extends TypeAdapter<TeamVisits> {
  @override
  final int typeId = 11;

  @override
  TeamVisits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamVisits(
      sId: fields[0] as String?,
      shop: fields[1] as String?,
      emp: fields[2] as String?,
      phone: fields[3] as String?,
      name: fields[4] as String?,
      reason: fields[5] as String?,
      type: fields[6] as String?,
      remarks: fields[7] as String?,
      location: fields[8] as TeamLocation?,
      createdAt: fields[9] as String?,
      updatedAt: fields[10] as String?,
      iV: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TeamVisits obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.shop)
      ..writeByte(2)
      ..write(obj.emp)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.reason)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.remarks)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.iV);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamVisitsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OdometerLocationAdapter extends TypeAdapter<OdometerLocation> {
  @override
  final int typeId = 12;

  @override
  OdometerLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OdometerLocation(
      longitude: fields[0] as double?,
      latitude: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, OdometerLocation obj) {
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
      other is OdometerLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamOdometersAdapter extends TypeAdapter<TeamOdometers> {
  @override
  final int typeId = 13;

  @override
  TeamOdometers read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamOdometers(
      sId: fields[0] as String?,
      user: fields[1] as String?,
      startReading: fields[2] as int?,
      endReading: fields[3] as int?,
      startCoordinate: fields[4] as OdometerLocation?,
      endCoordinate: fields[5] as OdometerLocation?,
      createdAt: fields[6] as String?,
      updatedAt: fields[7] as String?,
      iV: fields[8] as int?,
      startReadingImage: fields[9] as String?,
      startReadingImageThumbnail: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TeamOdometers obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.startReading)
      ..writeByte(3)
      ..write(obj.endReading)
      ..writeByte(4)
      ..write(obj.startCoordinate)
      ..writeByte(5)
      ..write(obj.endCoordinate)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.iV)
      ..writeByte(9)
      ..write(obj.startReadingImage)
      ..writeByte(10)
      ..write(obj.startReadingImageThumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamOdometersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LastActiveAdapter extends TypeAdapter<LastActive> {
  @override
  final int typeId = 14;

  @override
  LastActive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LastActive(
      location: fields[0] as TeamLocation?,
      time: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LastActive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.location)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LastActiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamLocationAdapter extends TypeAdapter<TeamLocation> {
  @override
  final int typeId = 15;

  @override
  TeamLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamLocation(
      longitude: fields[0] as double?,
      latitude: fields[1] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, TeamLocation obj) {
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
      other is TeamLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamProfileAdapter extends TypeAdapter<TeamProfile> {
  @override
  final int typeId = 16;

  @override
  TeamProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamProfile(
      thumbnailUrl: fields[0] as String?,
      url: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TeamProfile obj) {
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
      other is TeamProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
