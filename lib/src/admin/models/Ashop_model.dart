class AShop {
  Profile? profile;
  String? sId;
  String? name;
  String? ownerName;
  Location? location;
  String? email;
  String? phone;
  CreatedBy? createdBy;
  String? products;
  String? address;
  String? pincode;
  String? mapAddress;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Images>? images;

  AShop(
      {this.profile,
      this.sId,
      this.name,
      this.ownerName,
      this.location,
      this.email,
      this.phone,
      this.createdBy,
      this.products,
      this.address,
      this.pincode,
      this.mapAddress,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.images});

  AShop.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    sId = json['_id'];
    name = json['name'];
    ownerName = json['ownerName'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    email = json['email'];
    phone = json['phone'];
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    products = json['products'];
    address = json['address'];
    pincode = json['pincode'];
    mapAddress = json['mapAddress'];
    status = json['status'];
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
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['ownerName'] = ownerName;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['email'] = email;
    data['phone'] = phone;
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    data['products'] = products;
    data['address'] = address;
    data['pincode'] = pincode;
    data['mapAddress'] = mapAddress;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Profile {
  String? thumbnail;
  String? url;

  Profile({this.thumbnail, this.url});

  Profile.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbnail'] = thumbnail;
    data['url'] = url;
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

class CreatedBy {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? role;

  CreatedBy({this.sId, this.name, this.email, this.phone, this.role});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    return data;
  }
}

class Images {
  String? sId;
  String? url;
  bool? uploaded;
  String? thumbnailUrl;
  String? visitId;
  String? shopId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Images(
      {this.sId,
      this.url,
      this.uploaded,
      this.thumbnailUrl,
      this.visitId,
      this.shopId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Images.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    url = json['url'];
    uploaded = json['uploaded'];
    thumbnailUrl = json['thumbnailUrl'];
    visitId = json['visitId'];
    shopId = json['shopId'];
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
    data['shopId'] = shopId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
