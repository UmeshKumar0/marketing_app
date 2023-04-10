import 'package:hive/hive.dart';

part 'meeting_user.g.dart';

@HiveType(typeId: 45)
class MeetingUser {
  @HiveField(0)
  UserProfile? profile;
  @HiveField(1)
  String? sId;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? phone;

  MeetingUser({this.profile, this.sId, this.name, this.phone});

  MeetingUser.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? UserProfile.fromJson(json['profile']) : null;
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}

@HiveType(typeId: 46)
class UserProfile {
  @HiveField(0)
  String? thumbnailUrl;
  @HiveField(1)
  String? url;

  UserProfile({this.thumbnailUrl, this.url});

  UserProfile.fromJson(Map<String, dynamic> json) {
    thumbnailUrl = json['thumbnailUrl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbnailUrl'] = thumbnailUrl;
    data['url'] = url;
    return data;
  }
}
