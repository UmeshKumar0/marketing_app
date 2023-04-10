class AChat {
  String? sId;
  String? message;
  String? chatId;
  String? sender;
  bool? admin;
  String? messageType;
  bool? seen;
  bool? delivered;
  String? createdAt;

  AChat(
      {this.sId,
      this.message,
      this.chatId,
      this.sender,
      this.admin,
      this.messageType,
      this.seen,
      this.delivered,
      this.createdAt});

  AChat.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    chatId = json['chatId'];
    sender = json['sender'];
    admin = json['admin'];
    messageType = json['messageType'];
    seen = json['seen'];
    delivered = json['delivered'];
    createdAt = json['createdAt'];
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
    data['createdAt'] = createdAt;
    return data;
  }
}
