class AShopVisit {
  Location? location;
  String? sId;
  String? syncId;
  Shop? shop;
  Emp? emp;
  String? phone;
  String? name;
  String? reason;
  String? type;
  String? remarks;
  int? time;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Images>? images;

  AShopVisit(
      {this.location,
      this.sId,
      this.syncId,
      this.shop,
      this.emp,
      this.phone,
      this.name,
      this.reason,
      this.type,
      this.remarks,
      this.time,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.images});

  AShopVisit.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    syncId = json['syncId'] ?? 'N/A';
    shop = json['shop'] != null ? Shop.fromJson(json['shop']) : null;
    emp = json['emp'] != null ? Emp.fromJson(json['emp']) : null;
    phone = json['phone'] ?? 'N/A';
    name = json['name'] ?? 'N/A';
    reason = json['reason'] ?? 'N/A';
    type = json['type'] ?? 'N/A';
    remarks = json['remarks'] ?? 'N/A';
    time = json['time'] ?? 0;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = sId;
    data['syncId'] = syncId;
    if (shop != null) {
      data['shop'] = shop!.toJson();
    }
    if (emp != null) {
      data['emp'] = emp!.toJson();
    }
    data['phone'] = phone;
    data['name'] = name;
    data['reason'] = reason;
    data['type'] = type;
    data['remarks'] = remarks;
    data['time'] = time;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
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

class Shop {
  String? sId;
  String? name;
  String? phone;
  String? address;

  Shop({this.sId, this.name, this.phone, this.address});

  Shop.fromJson(Map<String, dynamic> json) {
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

class Emp {
  String? sId;
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

class Images {
  String? sId;
  String? url;
  bool? uploaded;
  String? thumbnailUrl;
  String? visitId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Images(
      {this.sId,
      this.url,
      this.uploaded,
      this.thumbnailUrl,
      this.visitId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Images.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    url = json['url'];
    uploaded = json['uploaded'];
    thumbnailUrl = json['thumbnailUrl'];
    visitId = json['visitId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['url'] = url;
    data['uploaded'] = uploaded;
    data['thumbnailUrl'] = thumbnailUrl;
    data['visitId'] = visitId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
