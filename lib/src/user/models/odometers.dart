import 'package:hive/hive.dart';

part 'odometers.g.dart';

@HiveType(typeId: 7)
class Odometers {
  @HiveField(0)
  StartCoordinate? startCoordinate;
  @HiveField(1)
  StartCoordinate? endCoordinate;
  @HiveField(2)
  String? sId;
  @HiveField(3)
  OdoMeterUser? user;
  @HiveField(4)
  int? startReading;
  @HiveField(5)
  String? createdAt;
  @HiveField(6)
  String? updatedAt;
  @HiveField(7)
  String? startReadingImage;
  @HiveField(8)
  String? startReadingImageThumbnail;
  @HiveField(9)
  int? endReading;
  @HiveField(10)
  String? endReadingImage;
  @HiveField(11)
  String? endReadingImageThumbnail;

  Odometers(
      {this.startCoordinate,
      this.endCoordinate,
      this.sId,
      this.user,
      this.startReading,
      this.createdAt,
      this.updatedAt,
      this.startReadingImage,
      this.startReadingImageThumbnail,
      this.endReading,
      this.endReadingImage,
      this.endReadingImageThumbnail});

  Odometers.fromJson(Map<String, dynamic> json) {
    startCoordinate = json['startCoordinate'] != null
        ? StartCoordinate.fromJson(json['startCoordinate'])
        : null;
    endCoordinate = json['endCoordinate'] != null
        ? StartCoordinate.fromJson(json['endCoordinate'])
        : null;
    sId = json['_id'];
    user = json['user'] != null ? OdoMeterUser.fromJson(json['user']) : null;
    startReading = json['startReading'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    startReadingImage = json['startReadingImage'];
    startReadingImageThumbnail = json['startReadingImageThumbnail'];
    endReading = json['endReading'];
    endReadingImage = json['endReadingImage'];
    endReadingImageThumbnail = json['endReadingImageThumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (startCoordinate != null) {
      data['startCoordinate'] = startCoordinate!.toJson();
    }
    if (endCoordinate != null) {
      data['endCoordinate'] = endCoordinate!.toJson();
    }
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['startReading'] = startReading;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['startReadingImage'] = startReadingImage;
    data['startReadingImageThumbnail'] = startReadingImageThumbnail;
    data['endReading'] = endReading;
    data['endReadingImage'] = endReadingImage;
    data['endReadingImageThumbnail'] = endReadingImageThumbnail;
    return data;
  }
}

@HiveType(typeId: 8)
class StartCoordinate {
  @HiveField(0)
  double? longitude;
  @HiveField(1)
  double? latitude;

  StartCoordinate({this.longitude, this.latitude});

  StartCoordinate.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

@HiveType(typeId: 9)
class OdoMeterUser {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? name;

  OdoMeterUser({this.sId, this.name});

  OdoMeterUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}
