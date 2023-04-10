import 'package:hive/hive.dart';

part 'visit_model.g.dart';

@HiveType(typeId: 17)
class VisitModel {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  ShopModel? shop;
  @HiveField(2)
  Emp? emp;
  @HiveField(3)
  String? reason;
  @HiveField(4)
  String? type;
  @HiveField(5)
  String? remarks;
  @HiveField(6)
  String? phone;
  @HiveField(7)
  String? name;
  @HiveField(8)
  UserLocation? location;
  @HiveField(9)
  String? createdAt;
  @HiveField(10)
  List<VisitImages>? images;
  @HiveField(11)
  String? syncId;

  VisitModel({
    this.sId,
    this.shop,
    this.emp,
    this.reason,
    this.type,
    this.remarks,
    this.location,
    this.createdAt,
    this.images,
    this.name,
    this.phone,
    this.syncId,
  });

  VisitModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    shop = json['shop'] != null ? ShopModel.fromJson(json['shop']) : null;
    emp = json['emp'] != null ? Emp.fromJson(json['emp']) : null;
    reason = json['reason'];
    type = json['type'];
    phone = json['phone'];
    name = json['name'];
    remarks = json['remarks'];
    location = json['location'] != null
        ? UserLocation.fromJson(json['location'])
        : null;
    createdAt = json['createdAt'];
    if (json['images'] != null) {
      images = <VisitImages>[];
      json['images'].forEach((v) {
        images!.add(VisitImages.fromJson(v));
      });
    }
    syncId = json['syncId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (shop != null) {
      data['shop'] = shop!.toJson();
    }
    if (emp != null) {
      data['emp'] = emp!.toJson();
    }
    data['reason'] = reason;
    data['type'] = type;
    data['remarks'] = remarks;
    data['phone'] = phone;
    data['name'] = name;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['createdAt'] = createdAt;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['syncId'] = syncId;
    return data;
  }
}

@HiveType(typeId: 18)
class ShopModel {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? address;

  ShopModel({this.sId, this.name, this.phone, this.address});

  ShopModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}

@HiveType(typeId: 19)
class Emp {
  @HiveField(0)
  String? sId;
  @HiveField(2)
  String? name;

  Emp({this.sId, this.name});

  Emp.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

@HiveType(typeId: 20)
class UserLocation {
  @HiveField(0)
  double? longitude;
  @HiveField(1)
  double? latitude;

  UserLocation({this.longitude, this.latitude});

  UserLocation.fromJson(Map<String, dynamic> json) {
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

@HiveType(typeId: 21)
class VisitImages {
  @HiveField(0)
  String? url;
  @HiveField(1)
  String? thumbnailUrl;

  VisitImages({this.url, this.thumbnailUrl});

  VisitImages.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    thumbnailUrl = json['thumbnailUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}
