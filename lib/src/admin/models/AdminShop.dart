import 'package:marketing/src/user/models/shop_image.dart';
import 'package:marketing/src/user/models/shop_model.dart';

class AdminShop {
  Profile? profile;
  String? sId;
  String? name;
  String? ownerName;
  Locations? location;
  String? email;
  String? phone;
  CreatedBy? createdBy;
  String? products;
  String? address;
  String? pincode;
  String? mapAddress;
  String? status;
  int? iV;
  String? updatedAt;
  List<ShopImage>? images;

  AdminShop(
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
      this.iV,
      this.updatedAt,
      this.images});

  AdminShop.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    sId = json['_id'];
    name = json['name'];
    ownerName = json['ownerName'];
    location =
        json['location'] != null ? Locations.fromJson(json['location']) : null;
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
    iV = json['__v'];
    updatedAt = json['updatedAt'];
    if (json['images'] != null) {
      images = <ShopImage>[];
      json['images'].forEach((v) {
        images!.add(ShopImage.fromJson(v));
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
    data['__v'] = iV;
    data['updatedAt'] = updatedAt;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
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
