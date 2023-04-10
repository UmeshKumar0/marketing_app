class AdminUser {
  LastActive? lastActive;
  AppMetadata? appMetadata;
  Sponsor? sponsor;
  String? sId;
  String? name;
  String? empId;
  String? email;
  String? phone;
  String? role;
  bool? active;
  List<String>? token;
  String? otp;
  List<String>? permissions;
  bool? writePermissions;

  AdminUser({
    this.lastActive,
    this.appMetadata,
    this.sponsor,
    this.sId,
    this.name,
    this.empId,
    this.email,
    this.phone,
    this.role,
    this.active,
    this.token,
    this.otp,
    this.permissions,
    this.writePermissions,
  });

  AdminUser.fromJson(Map<String, dynamic> json) {
    lastActive = json['lastActive'] != null
        ? LastActive.fromJson(json['lastActive'])
        : null;
    appMetadata = json['app_metadata'] != null
        ? AppMetadata.fromJson(json['app_metadata'])
        : null;
    sponsor =
        json['sponsor'] != null ? Sponsor.fromJson(json['sponsor']) : null;
    sId = json['_id'];
    name = json['name'];
    empId = json['emp_id'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    active = json['active'];
    token = json['token'].cast<String>();
    otp = json['otp'];
    permissions = json['permissions'].cast<String>();
    writePermissions = json['write_permissions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lastActive != null) {
      data['lastActive'] = lastActive!.toJson();
    }
    if (appMetadata != null) {
      data['app_metadata'] = appMetadata!.toJson();
    }
    if (sponsor != null) {
      data['sponsor'] = sponsor!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['emp_id'] = empId;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['active'] = active;
    data['token'] = token;
    data['otp'] = otp;
    data['permissions'] = permissions;
    data['write_permissions'] = writePermissions;
    return data;
  }
}

class LastActive {
  Location? location;
  String? time;
  String? address;

  LastActive({this.location, this.time, this.address});

  LastActive.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
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

class Location {
  double? longitude;
  double? latitude;

  Location({this.longitude, this.latitude});

  Location.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

class AppMetadata {
  List<Login>? login;
  List<Permissions>? permissions;

  AppMetadata({this.login, this.permissions});

  AppMetadata.fromJson(Map<String, dynamic> json) {
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

class Sponsor {
  String? sId;
  String? name;
  String? email;

  Sponsor({this.sId, this.name, this.email});

  Sponsor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
