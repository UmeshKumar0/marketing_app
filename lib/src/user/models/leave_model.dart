class LeaveModel {
  String? sId;
  LeaveUser? user;
  int? startDate;
  int? endDate;
  String? reason;
  String? status;
  String? leaveType;
  String? rejectionReason;

  LeaveModel({
    this.sId,
    this.user,
    this.startDate,
    this.endDate,
    this.reason,
    this.status,
    this.leaveType,
    this.rejectionReason,
  });

  LeaveModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? LeaveUser.fromJson(json['user']) : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    reason = json['reason'];
    status = json['status'];
    leaveType = json['leaveType'];
    rejectionReason = json['rejectionReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['reason'] = reason;
    data['status'] = status;
    data['leaveType'] = leaveType;
    data['rejectionReason'] = rejectionReason;
    return data;
  }
}

class LeaveUser {
  LeaveProfile? profile;
  String? sId;
  String? name;

  LeaveUser({this.profile, this.sId, this.name});

  LeaveUser.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? LeaveProfile.fromJson(json['profile']) : null;
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class LeaveProfile {
  String? thumbnailUrl;
  String? url;

  LeaveProfile({this.thumbnailUrl, this.url});

  LeaveProfile.fromJson(Map<String, dynamic> json) {
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
