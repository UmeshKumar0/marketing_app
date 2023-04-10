// ignore_for_file: unnecessary_new

import 'package:hive/hive.dart';
part 'meeting_model.g.dart';

@HiveType(typeId: 61)
class MeetingModel {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? user;
  @HiveField(2)
  int? date;
  @HiveField(3)
  MeetingShop? shop;
  @HiveField(4)
  int? strength;
  @HiveField(5)
  String? food;
  @HiveField(6)
  String? remarks;
  @HiveField(7)
  String? gift;
  @HiveField(8)
  String? status;
  @HiveField(9)
  List<String>? gallery;
  @HiveField(10)
  String? requestedUser;
  @HiveField(11)
  String? syncId;
  @HiveField(12)
  late bool synced;

  MeetingModel({
    this.sId,
    this.user,
    this.date,
    this.shop,
    this.strength,
    this.food,
    this.remarks,
    this.gift,
    this.status,
    this.gallery,
    this.requestedUser,
    this.syncId,
    this.synced = false,
  });

  MeetingModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    date = json['date'];
    shop = json['shop'] != null ? new MeetingShop.fromJson(json['shop']) : null;
    strength = json['strength'];
    food = json['food'];
    remarks = json['remarks'];
    gift = json['gift'];
    status = json['status'];
    gallery = json['gallery'].cast<String>();
    requestedUser = json["requestedUser"];
    syncId = json['syncId'];
    synced = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['date'] = date;
    if (shop != null) {
      data['shop'] = shop!.toJson();
    }
    data['strength'] = strength;
    data['food'] = food;
    data['remarks'] = remarks;
    data['gift'] = gift;
    data['status'] = status;
    data['gallery'] = gallery;
    data["requestedUser"] = requestedUser;
    data['syncId'] = syncId;
    return data;
  }
}

@HiveType(typeId: 62)
class MeetingShop {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? phone;

  MeetingShop({this.sId, this.name, this.email, this.phone});

  MeetingShop.fromJson(Map<String, dynamic> json) {
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
