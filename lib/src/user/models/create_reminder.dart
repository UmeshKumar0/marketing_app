import 'package:hive/hive.dart';

part 'create_reminder.g.dart';

@HiveType(typeId: 35)
class CreateReminder {
  @HiveField(0)
  String? visit;
  @HiveField(1)
  String? shop;
  @HiveField(2)
  String? remarks;
  @HiveField(3)
  String? date;
  @HiveField(4)
  String? syncId;

  CreateReminder({
    this.visit,
    this.shop,
    this.remarks,
    this.date,
    required this.syncId,
  });

  CreateReminder.fromJson(Map<String, dynamic> json) {
    visit = json['visit'];
    shop = json['shop'];
    remarks = json['remarks'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['visit'] = visit;
    data['shop'] = shop;
    data['remarks'] = remarks;
    data['date'] = date;
    return data;
  }
}
