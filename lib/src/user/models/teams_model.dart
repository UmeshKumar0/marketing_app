import 'package:hive/hive.dart';
part 'teams_model.g.dart';

@HiveType(typeId: 10)
class UserTeam {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  List<TeamVisits>? visits;
  @HiveField(4)
  List<TeamOdometers>? odometers;
  @HiveField(5)
  LastActive? lastActive;
  @HiveField(6)
  TeamProfile? profile;

  UserTeam({
    this.sId,
    this.name,
    this.email,
    this.visits,
    this.odometers,
    this.lastActive,
    this.profile,
  });

  UserTeam.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    lastActive = json['lastActive'] != null
        ? LastActive.fromJson(json['lastActive'])
        : null;
    profile =
        json['profile'] != null ? TeamProfile.fromJson(json['profile']) : null;
    if (json['visits'] != null) {
      visits = <TeamVisits>[];
      json['visits'].forEach((v) {
        visits!.add(TeamVisits.fromJson(v));
      });
    }
    if (json['odometers'] != null) {
      odometers = <TeamOdometers>[];
      json['odometers'].forEach((v) {
        odometers!.add(TeamOdometers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    if (lastActive != null) {
      data['lastActive'] = lastActive!.toJson();
    }
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (visits != null) {
      data['visits'] = visits!.map((v) => v.toJson()).toList();
    }
    if (odometers != null) {
      data['odometers'] = odometers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 11)
class TeamVisits {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? shop;
  @HiveField(2)
  String? emp;
  @HiveField(3)
  String? phone;
  @HiveField(4)
  String? name;
  @HiveField(5)
  String? reason;
  @HiveField(6)
  String? type;
  @HiveField(7)
  String? remarks;
  @HiveField(8)
  TeamLocation? location;
  @HiveField(9)
  String? createdAt;
  @HiveField(10)
  String? updatedAt;
  @HiveField(11)
  int? iV;

  TeamVisits({
    this.sId,
    this.shop,
    this.emp,
    this.phone,
    this.name,
    this.reason,
    this.type,
    this.remarks,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  TeamVisits.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shop = json['shop'];
    emp = json['emp'];
    phone = json['phone'];
    name = json['name'];
    reason = json['reason'];
    type = json['type'];
    remarks = json['remarks'];
    location = json['location'] != null
        ? TeamLocation.fromJson(json['location'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['shop'] = shop;
    data['emp'] = emp;
    data['phone'] = phone;
    data['name'] = name;
    data['reason'] = reason;
    data['type'] = type;
    data['remarks'] = remarks;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

@HiveType(typeId: 12)
class OdometerLocation {
  @HiveField(0)
  double? longitude;
  @HiveField(1)
  double? latitude;

  OdometerLocation({this.longitude, this.latitude});

  OdometerLocation.fromJson(Map<String, dynamic> json) {
    var long = json['longitude'];
    longitude = long.runtimeType == int ? long.toDouble() : long;
    var lat = json['latitude'];
    latitude = lat.runtimeType == int ? lat.toDouble() : lat;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

@HiveType(typeId: 13)
class TeamOdometers {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? user;
  @HiveField(2)
  int? startReading;
  @HiveField(3)
  int? endReading;
  @HiveField(4)
  OdometerLocation? startCoordinate;
  @HiveField(5)
  OdometerLocation? endCoordinate;
  @HiveField(6)
  String? createdAt;
  @HiveField(7)
  String? updatedAt;
  @HiveField(8)
  int? iV;
  @HiveField(9)
  String? startReadingImage;
  @HiveField(10)
  String? startReadingImageThumbnail;

  TeamOdometers({
    this.sId,
    this.user,
    this.startReading,
    this.endReading,
    this.startCoordinate,
    this.endCoordinate,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.startReadingImage,
    this.startReadingImageThumbnail,
  });

  TeamOdometers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    startReading = json['startReading'];
    endReading = json['endReading'];
    startCoordinate = json['startCoordinate'] != null
        ? OdometerLocation.fromJson(json['startCoordinate'])
        : null;
    endCoordinate = json['endCoordinate'] != null
        ? OdometerLocation.fromJson(json['endCoordinate'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    startReadingImage = json['startReadingImage'];
    startReadingImageThumbnail = json['startReadingImageThumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['startReading'] = startReading;
    data['endReading'] = endReading;
    if (startCoordinate != null) {
      data['startCoordinate'] = startCoordinate!.toJson();
    }
    if (endCoordinate != null) {
      data['endCoordinate'] = endCoordinate!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['startReadingImage'] = startReadingImage;
    data['startReadingImageThumbnail'] = startReadingImageThumbnail;
    return data;
  }
}

@HiveType(typeId: 14)
class LastActive {
  @HiveField(0)
  TeamLocation? location;
  @HiveField(1)
  String? time;

  LastActive({this.location, this.time});

  LastActive.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? TeamLocation.fromJson(json['location'])
        : null;
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['time'] = time;
    return data;
  }
}

@HiveType(typeId: 15)
class TeamLocation {
  @HiveField(0)
  double? longitude;
  @HiveField(1)
  double? latitude;

  TeamLocation({this.longitude, this.latitude});

  TeamLocation.fromJson(Map<String, dynamic> json) {
    var long = json['longitude'];
    longitude = long.runtimeType == int ? long.toDouble() : long;
    var lat = json['latitude'];
    latitude = lat.runtimeType == int ? lat.toDouble() : lat;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

@HiveType(typeId: 16)
class TeamProfile {
  @HiveField(0)
  String? thumbnailUrl;
  @HiveField(1)
  String? url;

  TeamProfile({this.thumbnailUrl, this.url});

  TeamProfile.fromJson(Map<String, dynamic> json) {
    thumbnailUrl = json['thumbnailUrl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbnailUrl'] = thumbnailUrl;
    data['url'] = url;
    return data;
  }
}
