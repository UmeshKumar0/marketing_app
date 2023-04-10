// ignore_for_file: file_names

import 'package:hive/hive.dart';
import 'package:marketing/src/user/models/location_model.dart';

part 'shopCreate.g.dart';

@HiveType(typeId: 29)
class ShopCreate {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? shopOwner;
  @HiveField(2)
  String? shopEmail;
  @HiveField(3)
  String? shopPhone;
  @HiveField(4)
  String? shopAddress;
  @HiveField(5)
  String? shopBrand;
  @HiveField(6)
  String? shopProducts;
  @HiveField(7)
  String? shopPincode;
  @HiveField(8)
  LocationModel? locationModel;
  @HiveField(9)
  String? mapAddress;
  @HiveField(10)
  List? shopImg;
  @HiveField(11)
  String? time;
  @HiveField(12)
  String? id;

  ShopCreate({
    this.name,
    this.shopAddress,
    this.shopBrand,
    this.shopEmail,
    this.shopOwner,
    this.shopPhone,
    this.shopPincode,
    this.shopProducts,
    this.locationModel,
    this.mapAddress,
    this.shopImg,
    this.time,
    this.id,
  });

  Map<String, String> toJSON() {
    Map<String, String> data = {};
    data['name'] = name!;
    data['ownerName'] = shopOwner!;
    data['email'] = shopEmail!;
    data['phone'] = shopPhone!;
    data['address'] = shopAddress!;
    data['brands'] = shopBrand!;
    data['products'] = shopProducts!;
    data['pincode'] = shopPincode!;
    data['location'] = locationModel?.toJson() as String;
    data['mapAddress'] = mapAddress!;
    data['images'] = shopImg?.toString() as String;
    return data;
  }
}
