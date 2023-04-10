import 'dart:core';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  User? user;
  @HiveField(1)
  String? token;

  UserModel({this.user, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? phone;
  @HiveField(4)
  String? role;
  @HiveField(5)
  String? dob;
  @HiveField(6)
  bool? active;
  @HiveField(7)
  Images? images;
  @HiveField(8)
  String? emp;

  User({
    this.sId,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.dob,
    this.active,
    this.images,
    this.emp,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    active = json['active'];
    dob = json['dob'];
    images =
        json['profile'] != null ? Images.fromJson(json['profile']) : Images();
    emp = json['emp_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['active'] = active;
    data['dob'] = dob;
    if (images != null) {
      data['profile'] = images!.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 2)
class Images {
  @HiveField(0)
  String? url;
  @HiveField(1)
  String? thumbnailUrl;

  Images({this.url = "N/A", this.thumbnailUrl = "N/A"});

  Images.fromJson(Map<String, dynamic> json) {
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
