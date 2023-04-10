
class GroupItem {
  String? sId;
  String? name;
  String? title;
  TeamLead? teamLead;
  bool? isActive;
  List<Members>? members;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GroupItem(
      {this.sId,
      this.name,
      this.title,
      this.teamLead,
      this.isActive,
      this.members,
      this.createdAt,
      this.updatedAt,
      this.iV});

  GroupItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    title = json['title'];
    teamLead = json['teamLead'] != null
        ? TeamLead.fromJson(json['teamLead'])
        : null;
    isActive = json['isActive'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['title'] = title;
    if (teamLead != null) {
      data['teamLead'] = teamLead!.toJson();
    }
    data['isActive'] = isActive;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class TeamLead {
  String? sId;
  String? name;
  String? phone;

  TeamLead({this.sId, this.name, this.phone});

  TeamLead.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}


class Members {
  String? sId;
  String? name;
  String? phone;

  Members({this.sId, this.name, this.phone});

  Members.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}