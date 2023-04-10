import 'package:hive/hive.dart';

part 'location_model.g.dart';

@HiveType(typeId: 30)
class LocationModel {
  @HiveField(0)
  String? longitude;
  @HiveField(1)
  String? latitude;

  LocationModel({this.longitude, this.latitude});

  LocationModel.fromJson(Map<String, dynamic> json) {
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
