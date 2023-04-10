class AttendanceUser {
  String? sId;
  User? user;
  int? value;
  int? date;
  bool? markedAbsent;
  String? createdAt;

  AttendanceUser({
    this.sId,
    this.user,
    this.value,
    this.date,
    this.markedAbsent,
    this.createdAt,
  });

  AttendanceUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    value = json['value'];
    date = json['date'];
    markedAbsent = json['markedAbsent'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['value'] = value;
    data['date'] = date;
    data['markedAbsent'] = markedAbsent;
    data['createdAt'] = createdAt;
    return data;
  }
}

class User {
  String? sId;
  String? name;

  User({this.sId, this.name});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}
