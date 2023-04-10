import 'package:hive/hive.dart';

part 'user_notification.g.dart';

@HiveType(typeId: 22)
class UserNotification {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? userId;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? message;
  @HiveField(4)
  String? type;
  @HiveField(5)
  String? payload;
  @HiveField(6)
  String? args;
  @HiveField(7)
  String? date;
  @HiveField(8)
  bool? sended;
  @HiveField(9)
  bool? read;
  @HiveField(10)
  int? iV;
  @HiveField(11)
  String? createdAt;
  @HiveField(12)
  String? updatedAt;
  UserNotification(
      {this.sId,
      this.userId,
      this.title,
      this.message,
      this.type,
      this.payload,
      this.args,
      this.date,
      this.sended,
      this.read,
      this.iV,
      this.createdAt,
      this.updatedAt});

  UserNotification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    payload = json['payload'];
    args = json['args'];
    date = json['date'];
    sended = json['sended'];
    read = json['read'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['title'] = title;
    data['message'] = message;
    data['type'] = type;
    data['payload'] = payload;
    data['args'] = args;
    data['date'] = date;
    data['sended'] = sended;
    data['read'] = read;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
