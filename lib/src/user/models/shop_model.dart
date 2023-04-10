import 'package:hive/hive.dart';
part 'shop_model.g.dart';

@HiveType(typeId: 3)
class Shops {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? ownerName;
  @HiveField(3)
  Locations? location;
  @HiveField(4)
  String? email;
  @HiveField(5)
  String? phone;
  @HiveField(6)
  String? address;
  @HiveField(7)
  String? pincode;
  @HiveField(8)
  String? mapAddress;
  @HiveField(9)
  String? status;
  @HiveField(10)
  Profile? profile;
  @HiveField(11)
  late bool uploaded;
  @HiveField(12)
  String? syncId;
  @HiveField(13)
  String? createdAt;

  Shops({
    this.sId,
    this.name,
    this.ownerName,
    this.location,
    this.email,
    this.phone,
    this.address,
    this.pincode,
    this.mapAddress,
    this.status,
    this.profile,
    this.uploaded = false,
    this.syncId,
    this.createdAt,
  });

  Shops.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    ownerName = json['ownerName'];
    location =
        json['location'] != null ? Locations.fromJson(json['location']) : null;
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    pincode = json['pincode'];
    mapAddress = json['mapAddress'];
    status = json['status'];
    profile = json['profile'] != null
        ? Profile.fromJson(json['profile'])
        : Profile(thumbnail: 'N/A', url: 'N/A');
    syncId = json['syncId'];
    uploaded = true;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['syncId'] = syncId;
    data['ownerName'] = ownerName;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['pincode'] = pincode;
    data['mapAddress'] = mapAddress;
    data['status'] = status;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['createdAt'] = createdAt;
    return data;
  }
}

@HiveType(typeId: 4)
class Locations {
  @HiveField(0)
  String? type;
  @HiveField(1)
  List<double>? coordinates;
  @HiveField(2)
  String? sId;

  Locations({this.type, this.coordinates, this.sId});

  Locations.fromJson(Map<String, dynamic> json) {
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

@HiveType(typeId: 5)
class Profile {
  @HiveField(0)
  String? thumbnail;
  @HiveField(1)
  String? url;

  Profile({this.thumbnail, this.url});

  Profile.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['thumbnail'] = thumbnail;
    data['url'] = url;
    return data;
  }
}
