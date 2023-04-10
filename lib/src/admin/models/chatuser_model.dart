class ChatUserModel {
  String? sId;
  String? name;
  String? type;
  List<UserIds>? userIds;
  String? createdBy;
  int? iV;
  LastMessage? lastMessage;
  int? count;

  ChatUserModel(
      {this.sId,
      this.name,
      this.type,
      this.userIds,
      this.createdBy,
      this.iV,
      this.lastMessage,
      this.count});

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];

    if (json['userIds'] != null) {
      userIds = <UserIds>[];
      json['userIds'].forEach((v) {
        userIds!.add(UserIds.fromJson(v));
      });
    }
    createdBy = json['createdBy'];
    iV = json['__v'];
    lastMessage = json['lastMessage'].runtimeType == String
        ? null
        : json['lastMessage'] != null
            ? LastMessage.fromJson(json['lastMessage'])
            : null;
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['type'] = type;

    if (userIds != null) {
      data['userIds'] = userIds!.map((v) => v.toJson()).toList();
    }
    data['createdBy'] = createdBy;
    data['__v'] = iV;
    if (lastMessage != null) {
      data['lastMessage'] = lastMessage!.toJson();
    }
    data['count'] = count;
    return data;
  }
}

class UserIds {
  String? sId;
  String? name;
  Profile? profile;

  UserIds({this.sId, this.name, this.profile});

  UserIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? thumbnailUrl;
  String? url;

  Profile({this.thumbnailUrl, this.url});

  Profile.fromJson(Map<String, dynamic> json) {
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

class LastMessage {
  String? sId;
  String? message;
  String? chatId;
  String? sender;
  bool? admin;
  String? messageType;
  bool? seen;
  bool? delivered;
  String? createdAt;
  String? updatedAt;
  int? iV;

  LastMessage(
      {this.sId,
      this.message,
      this.chatId,
      this.sender,
      this.admin,
      this.messageType,
      this.seen,
      this.delivered,
      this.createdAt,
      this.updatedAt,
      this.iV});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    message = json['message'];
    chatId = json['chatId'];
    sender = json['sender'];
    admin = json['admin'];
    messageType = json['messageType'];
    seen = json['seen'];
    delivered = json['delivered'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
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
    data['updatedAt'] = updatedAt;
    return data;
  }
}
