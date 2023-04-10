import 'package:hive/hive.dart';
part 'reminder_model.g.dart';

@HiveType(typeId: 23)
class Reminders {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  ReminderEmp? emp;
  @HiveField(2)
  ReminderVisit? visit;
  @HiveField(3)
  ReminderShop? shop;
  @HiveField(4)
  String? remarks;
  @HiveField(5)
  String? date;
  @HiveField(6)
  String? status;
  @HiveField(7)
  late bool uploaded;

  Reminders({
    this.sId,
    this.emp,
    this.visit,
    this.shop,
    this.remarks,
    this.date,
    this.status,
    this.uploaded = true,
  });

  Reminders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    emp = json['emp'] != null ? ReminderEmp.fromJson(json['emp']) : null;
    visit =
        json['visit'] != null ? ReminderVisit.fromJson(json['visit']) : null;
    shop = json['shop'] != null ? ReminderShop.fromJson(json['shop']) : null;
    remarks = json['remarks'];
    date = json['date'];
    status = json['status'];
    uploaded = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (emp != null) {
      data['emp'] = emp!.toJson();
    }
    if (visit != null) {
      data['visit'] = visit!.toJson();
    }
    if (shop != null) {
      data['shop'] = shop!.toJson();
    }
    data['remarks'] = remarks;
    data['date'] = date;
    data['status'] = status;
    return data;
  }
}

@HiveType(typeId: 24)
class ReminderEmp {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? name;

  ReminderEmp({this.sId, this.name});

  ReminderEmp.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

@HiveType(typeId: 25)
class ReminderVisit {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? reason;
  @HiveField(2)
  String? type;
  @HiveField(3)
  String? remarks;

  ReminderVisit({this.sId, this.reason, this.type, this.remarks});

  ReminderVisit.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    reason = json['reason'];
    type = json['type'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['reason'] = reason;
    data['type'] = type;
    data['remarks'] = remarks;
    return data;
  }
}

@HiveType(typeId: 26)
class ReminderShop {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? address;

  ReminderShop({this.sId, this.name, this.phone, this.address});

  ReminderShop.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}
