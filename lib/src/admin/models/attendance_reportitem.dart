class AttendanceReportItem {
  String? sId;
  int? date;
  int? absent;
  int? present;
  int? halfDay;

  AttendanceReportItem(
      {this.sId, this.date, this.absent, this.present, this.halfDay});

  AttendanceReportItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    date = json['date'];
    absent = json['absent'];
    present = json['present'];
    halfDay = json['half_day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['date'] = date;
    data['absent'] = absent;
    data['present'] = present;
    data['half_day'] = halfDay;
    return data;
  }
}
