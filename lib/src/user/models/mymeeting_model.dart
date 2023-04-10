class MyMeetingModel {
  String? sId;
  String? syncId;
  MyMeetingUser? user;
  MyMeetingUser? requestedUser;
  int? date;
  MyMeetingShop? shop;
  int? strength;
  String? remarks;
  String? gift;
  String? status;
  List<dynamic>? gallery;

  MyMeetingModel(
      {this.sId,
      this.syncId,
      this.user,
      this.requestedUser,
      this.date,
      this.shop,
      this.strength,
      this.remarks,
      this.gift,
      this.status,
      this.gallery});

  MyMeetingModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    syncId = json['syncId'];
    user =
        json['user'] != null ? MyMeetingUser.fromJson(json['user']) : null;
    requestedUser = json['requestedUser'] != null
        ? MyMeetingUser.fromJson(json['requestedUser'])
        : null;
    date = json['date'];
    shop =
        json['shop'] != null ? MyMeetingShop.fromJson(json['shop']) : null;
    strength = json['strength'];
    remarks = json['remarks'];
    gift = json['gift'];
    status = json['status'];
    gallery = json['gallery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['syncId'] = syncId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (requestedUser != null) {
      data['requestedUser'] = requestedUser!.toJson();
    }
    data['date'] = date;
    if (shop != null) {
      data['shop'] = shop!.toJson();
    }
    data['strength'] = strength;
    data['remarks'] = remarks;
    data['gift'] = gift;
    data['status'] = status;
    data['gallery'] = gallery;
    return data;
  }
}

class MyMeetingShop {
  String? sId;
  String? name;
  Location? location;
  String? email;
  String? phone;
  String? address;
  String? pincode;
  String? mapAddress;

  MyMeetingShop(
      {this.sId,
      this.name,
      this.location,
      this.email,
      this.phone,
      this.address,
      this.pincode,
      this.mapAddress});

  MyMeetingShop.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    pincode = json['pincode'];
    mapAddress = json['mapAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['pincode'] = pincode;
    data['mapAddress'] = mapAddress;
    return data;
  }
}

class MyMeetingUser {
  String? sId;
  String? name;
  String? phone;

  MyMeetingUser({this.sId, this.name, this.phone});

  MyMeetingUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;
  String? sId;

  Location({this.type, this.coordinates, this.sId});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    data['_id'] = sId;
    return data;
  }
}
