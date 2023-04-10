class OdoVisit {
  int? count;
  String? time;

  OdoVisit({this.count, this.time});

  OdoVisit.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['time'] = time;
    return data;
  }
}

// class AOdometer {
//   StartCoordinate? startCoordinate;
//   Time? time;
//   String? sId;
//   User? user;
//   int? startReading;
//   String? createdAt;
//   String? updatedAt;
//   var iV;
//   String? startReadingImage;
//   String? startReadingImageThumbnail;

//   AOdometer(
//       {this.startCoordinate,
//       this.time,
//       this.sId,
//       this.user,
//       this.startReading,
//       this.createdAt,
//       this.updatedAt,
//       this.iV,
//       this.startReadingImage,
//       this.startReadingImageThumbnail});

//   AOdometer.fromJson(Map<String, dynamic> json) {
//     startCoordinate = json['startCoordinate'] != null
//         ? StartCoordinate.fromJson(json['startCoordinate'])
//         : null;
//     time = json['time'] != null ? Time.fromJson(json['time']) : null;
//     sId = json['_id'];
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//     startReading = json['startReading'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//     startReadingImage = json['startReadingImage'];
//     startReadingImageThumbnail = json['startReadingImageThumbnail'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (startCoordinate != null) {
//       data['startCoordinate'] = startCoordinate!.toJson();
//     }
//     if (time != null) {
//       data['time'] = time!.toJson();
//     }
//     data['_id'] = sId;
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     data['startReading'] = startReading;
//     data['createdAt'] = createdAt;
//     data['updatedAt'] = updatedAt;
//     data['__v'] = iV;
//     data['startReadingImage'] = startReadingImage;
//     data['startReadingImageThumbnail'] = startReadingImageThumbnail;
//     return data;
//   }
// }

// class StartCoordinate {
//   double? longitude;
//   double? latitude;

//   StartCoordinate({this.longitude, this.latitude});

//   StartCoordinate.fromJson(Map<String, dynamic> json) {
//     longitude = json['longitude'];
//     latitude = json['latitude'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['longitude'] = longitude;
//     data['latitude'] = latitude;
//     return data;
//   }
// }

// class Time {
//   int? startTime;

//   Time({this.startTime});

//   Time.fromJson(Map<String, dynamic> json) {
//     startTime = json['startTime'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['startTime'] = startTime;
//     return data;
//   }
// }

// class User {
//   LastActive? lastActive;
//   AppMetadata? appMetadata;
//   String? sId;
//   String? name;

//   User({this.lastActive, this.appMetadata, this.sId, this.name});

//   User.fromJson(Map<String, dynamic> json) {
//     lastActive = json['lastActive'] != null
//         ? LastActive.fromJson(json['lastActive'])
//         : null;
//     appMetadata = json['app_metadata'] != null
//         ? AppMetadata.fromJson(json['app_metadata'])
//         : null;
//     sId = json['_id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (lastActive != null) {
//       data['lastActive'] = lastActive!.toJson();
//     }
//     if (appMetadata != null) {
//       data['app_metadata'] = appMetadata!.toJson();
//     }
//     data['_id'] = sId;
//     data['name'] = name;
//     return data;
//   }
// }

// class LastActive {
//   StartCoordinate? location;
//   String? time;
//   String? address;

//   LastActive({this.location, this.time, this.address});

//   LastActive.fromJson(Map<String, dynamic> json) {
//     location = json['location'] != null
//         ? StartCoordinate.fromJson(json['location'])
//         : null;
//     time = json['time'];
//     address = json['address'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (location != null) {
//       data['location'] = location!.toJson();
//     }
//     data['time'] = time;
//     data['address'] = address;
//     return data;
//   }
// }

// class AppMetadata {
//   String? version;
//   List<Login>? login;
//   List<Permissions>? permissions;

//   AppMetadata({this.version, this.login, this.permissions});

//   AppMetadata.fromJson(Map<String, dynamic> json) {
//     version = json['version'];
//     if (json['login'] != null) {
//       login = <Login>[];
//       json['login'].forEach((v) {
//         login!.add(Login.fromJson(v));
//       });
//     }
//     if (json['permissions'] != null) {
//       permissions = <Permissions>[];
//       json['permissions'].forEach((v) {
//         permissions!.add(Permissions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['version'] = version;
//     if (login != null) {
//       data['login'] = login!.map((v) => v.toJson()).toList();
//     }
//     if (permissions != null) {
//       data['permissions'] = permissions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Login {
//   String? device;
//   int? time;
//   String? actionType;
//   String? sId;

//   Login({this.device, this.time, this.actionType, this.sId});

//   Login.fromJson(Map<String, dynamic> json) {
//     device = json['device'];
//     time = json['time'];
//     actionType = json['action_type'];
//     sId = json['_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['device'] = device;
//     data['time'] = time;
//     data['action_type'] = actionType;
//     data['_id'] = sId;
//     return data;
//   }
// }

// class Permissions {
//   String? key;
//   bool? value;
//   String? sId;

//   Permissions({this.key, this.value, this.sId});

//   Permissions.fromJson(Map<String, dynamic> json) {
//     key = json['key'];
//     value = json['value'];
//     sId = json['_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['key'] = key;
//     data['value'] = value;
//     data['_id'] = sId;
//     return data;
//   }
// }

class AOdometer {
  StartCoordinate? startCoordinate;
  StartCoordinate? endCoordinate;
  Time? time;
  String? sId;
  User? user;
  int? startReading;
  String? createdAt;
  String? startReadingImage;
  String? startReadingImageThumbnail;
  int? endReading;
  String? endReadingImage;
  String? endReadingImageThumbnail;

  AOdometer(
      {this.startCoordinate,
      this.endCoordinate,
      this.time,
      this.sId,
      this.user,
      this.startReading,
      this.createdAt,
      this.startReadingImage,
      this.startReadingImageThumbnail,
      this.endReading,
      this.endReadingImage,
      this.endReadingImageThumbnail});

  AOdometer.fromJson(Map<String, dynamic> json) {
    startCoordinate = json['startCoordinate'] != null
        ? StartCoordinate.fromJson(json['startCoordinate'])
        : null;
    endCoordinate = json['endCoordinate'] != null
        ? StartCoordinate.fromJson(json['endCoordinate'])
        : null;
    time = json['time'] != null ? Time.fromJson(json['time']) : null;
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    startReading = json['startReading'] != null
        ? json['startReading'].runtimeType == double
            ? json['startReading'].toInt()
            : json['startReading']
        : null;
    createdAt = json['createdAt'];
    startReadingImage = json['startReadingImage'];
    startReadingImageThumbnail = json['startReadingImageThumbnail'];
    endReading = json['endReading'] != null
        ? json['endReading'].runtimeType == double
            ? json['endReading'].toInt()
            : json['endReading']
        : null;
    endReadingImage = json['endReadingImage'];
    endReadingImageThumbnail = json['endReadingImageThumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (startCoordinate != null) {
      data['startCoordinate'] = startCoordinate!.toJson();
    }
    if (endCoordinate != null) {
      data['endCoordinate'] = endCoordinate!.toJson();
    }
    if (time != null) {
      data['time'] = time!.toJson();
    }
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['startReading'] = startReading ?? 0;
    data['createdAt'] = createdAt;
    data['startReadingImage'] = startReadingImage ?? 0;
    data['startReadingImageThumbnail'] = startReadingImageThumbnail ?? 'N/A';
    data['endReading'] = endReading ?? 0;
    data['endReadingImage'] = endReadingImage ?? 'N/A';
    data['endReadingImageThumbnail'] = endReadingImageThumbnail ?? 'N/A';
    return data;
  }
}

class StartCoordinate {
  double? longitude;
  double? latitude;

  StartCoordinate({this.longitude, this.latitude});

  StartCoordinate.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'].runtimeType == int
        ? json['longitude'].toDouble()
        : json['longitude'];
    latitude = json['latitude'].runtimeType == int
        ? json['latitude'].toDouble()
        : json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

class Time {
  int? startTime;
  int? endTime;

  Time({this.startTime, this.endTime});

  Time.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}

class User {
  LastActive? lastActive;
  AppMetadata? appMetadata;
  String? sId;
  String? name;

  User({this.lastActive, this.appMetadata, this.sId, this.name});

  User.fromJson(Map<String, dynamic> json) {
    lastActive = json['lastActive'] != null
        ? LastActive.fromJson(json['lastActive'])
        : null;
    appMetadata = json['app_metadata'] != null
        ? AppMetadata.fromJson(json['app_metadata'])
        : null;
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lastActive != null) {
      data['lastActive'] = lastActive!.toJson();
    }
    if (appMetadata != null) {
      data['app_metadata'] = appMetadata!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class LastActive {
  StartCoordinate? location;
  String? time;
  String? address;

  LastActive({this.location, this.time, this.address});

  LastActive.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? StartCoordinate.fromJson(json['location'])
        : null;
    time = json['time'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['time'] = time;
    data['address'] = address;
    return data;
  }
}

class AppMetadata {
  String? version;
  List<Login>? login;
  List<Permissions>? permissions;

  AppMetadata({this.version, this.login, this.permissions});

  AppMetadata.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    if (json['login'] != null) {
      login = <Login>[];
      json['login'].forEach((v) {
        login!.add(Login.fromJson(v));
      });
    }
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    if (login != null) {
      data['login'] = login!.map((v) => v.toJson()).toList();
    }
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Login {
  String? device;
  int? time;
  String? actionType;
  String? sId;

  Login({this.device, this.time, this.actionType, this.sId});

  Login.fromJson(Map<String, dynamic> json) {
    device = json['device'];
    time = json['time'];
    actionType = json['action_type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device'] = device;
    data['time'] = time;
    data['action_type'] = actionType;
    data['_id'] = sId;
    return data;
  }
}

class Permissions {
  String? key;
  bool? value;
  String? sId;

  Permissions({this.key, this.value, this.sId});

  Permissions.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    data['_id'] = sId;
    return data;
  }
}
