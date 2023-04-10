class AppHeaders {
  AttendanceStats? attendanceStats;
  List<SingleVisit>? singleVisit;
  List<SingleVisit>? multiVisit;
  List<SingleVisit>? notVisiting;
  List<SingleVisit>? absentUser;

  AppHeaders({
    this.attendanceStats,
    this.singleVisit,
    this.multiVisit,
    this.notVisiting,
    this.absentUser,
  });

  AppHeaders.fromJson(Map<String, dynamic> json) {
    attendanceStats = json['attendanceStats'] != null
        ? AttendanceStats.fromJson(json['attendanceStats'])
        : null;
    if (json['singleVisit'] != null) {
      singleVisit = <SingleVisit>[];
      json['singleVisit'].forEach((v) {
        singleVisit!.add(SingleVisit.fromJson(v));
      });
    }
    if (json['multiVisit'] != null) {
      multiVisit = <SingleVisit>[];
      json['multiVisit'].forEach((v) {
        multiVisit!.add(SingleVisit.fromJson(v));
      });
    }
    if (json['notVisiting'] != null) {
      notVisiting = <SingleVisit>[];
      json['notVisiting'].forEach((v) {
        notVisiting!.add(SingleVisit.fromJson(v));
      });
    }
    if (json['absentUser'] != null) {
      absentUser = <SingleVisit>[];
      json['absentUser'].forEach((v) {
        absentUser!.add(SingleVisit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (attendanceStats != null) {
      data['attendanceStats'] = attendanceStats!.toJson();
    }
    if (singleVisit != null) {
      data['singleVisit'] = singleVisit!.map((v) => v.toJson()).toList();
    }
    if (multiVisit != null) {
      data['multiVisit'] = multiVisit!.map((v) => v.toJson()).toList();
    }
    if (notVisiting != null) {
      data['notVisiting'] = notVisiting!.map((v) => v.toJson()).toList();
    }
    if (absentUser != null) {
      data['absentUser'] = absentUser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceStats {
  int? absent;
  int? present;

  AttendanceStats({this.absent=0, this.present=0});

  AttendanceStats.fromJson(Map<String, dynamic> json) {
    absent = json['absent'] ?? 0;
    present = json['present'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['absent'] = absent;
    data['present'] = present;
    return data;
  }
}

class SingleVisit {
  String? sId;
  String? name;
  String? empId;
  String? email;
  String? phone;
  int? count;

  SingleVisit(
      {this.sId, this.name, this.empId, this.email, this.phone, this.count});

  SingleVisit.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    empId = json['emp_id'];
    email = json['email'];
    phone = json['phone'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['emp_id'] = empId;
    data['email'] = email;
    data['phone'] = phone;
    data['count'] = count;
    return data;
  }
}
