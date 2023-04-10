class CreatedMeetings {
  String? sId;
  String? syncId;
  String? user;
  String? requestedUser;
  int? date;
  int? strength;
  String? remarks;
  String? gift;
  String? status;
  List<String>? gallery;
  String? createdAt;
  String? updatedAt;
  CreatedShop? shop;
  int? iV;
  List<UserResponse>? userResponse;

  CreatedMeetings(
      {this.sId,
      this.syncId,
      this.user,
      this.requestedUser,
      this.date,
      this.strength,
      this.remarks,
      this.gift,
      this.status,
      this.gallery,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.userResponse});

  CreatedMeetings.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    syncId = json['syncId'];
    user = json['user'];
    requestedUser = json['requestedUser'];
    date = json['date'];
    strength = json['strength'];
    remarks = json['remarks'];
    gift = json['gift'];
    status = json['status'];
    gallery = json['gallery'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['userResponse'] != null) {
      userResponse = <UserResponse>[];
      json['userResponse'].forEach((v) {
        userResponse!.add(UserResponse.fromJson(v));
      });
    }
    shop = json['shop'] != null ? CreatedShop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['syncId'] = syncId;
    data['user'] = user;
    data['requestedUser'] = requestedUser;
    data['date'] = date;
    data['strength'] = strength;
    data['remarks'] = remarks;
    data['gift'] = gift;
    data['status'] = status;
    data['gallery'] = gallery;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (userResponse != null) {
      data['userResponse'] = userResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserResponse {
  String? sId;

  UserResponse({this.sId});

  UserResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    return data;
  }
}

class CreatedShop {
  String? sId;
  String? name;
  String? email;
  String? phone;

  CreatedShop({this.sId, this.name, this.email, this.phone});

  CreatedShop.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
