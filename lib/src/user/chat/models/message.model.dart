
import 'package:hive/hive.dart';
part 'message.model.g.dart';
@HiveType(typeId: 78)
class Message {
  @HiveField(0)
  String? sId;

  @HiveField(1)
  String? message;

  @HiveField(2)
  String? chatId;

  @HiveField(3)
  String? sender;

  @HiveField(4)
  bool? admin;

  @HiveField(5)
  String? messageType;

  @HiveField(6)
  bool? seen;

  @HiveField(7)
  bool? delivered;

  Message({
    this.sId,
    this.message,
    this.chatId,
    this.sender,
    this.admin,
    this.messageType,
    this.seen,
    this.delivered,
  });

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    chatId = json['chatId'];
    sender = json['sender'];
    admin = json['admin'];
    messageType = json['messageType'];
    seen = json['seen'];
    delivered = json['delivered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['message'] = message;
    data['chatId'] = chatId;
    data['sender'] = sender;
    data['admin'] = admin;
    data['messageType'] = messageType;
    data['seen'] = seen;
    data['delivered'] = delivered;
    return data;
  }
}
