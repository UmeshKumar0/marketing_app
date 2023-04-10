class ChatUsers {
  String? sId;
  String? name;
  String? adminName;
  String? type;
  List<String>? admins;

  ChatUsers({this.sId, this.name, this.adminName, this.type, this.admins});

  ChatUsers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    adminName = json['admin_name'];
    type = json['type'];
    if (json['admins'] != null) {
      admins = [];
      json['admins'].forEach((v) {
        admins!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['admin_name'] = adminName;
    data['type'] = type;
    if (admins != null) {
      data['admins'] = admins!.map((v) => v).toList();
    }
    return data;
  }
}
