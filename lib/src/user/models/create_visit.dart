import 'package:hive/hive.dart';
import 'package:marketing/src/user/models/create_reminder.dart';
part 'create_visit.g.dart';

@HiveType(typeId: 32)
class CreateVisit {
  @HiveField(1)
  String? shop;
  @HiveField(2)
  String? reason;
  @HiveField(3)
  String type;
  @HiveField(4)
  String? phone;
  @HiveField(5)
  String? name;
  @HiveField(6)
  String remarks;
  @HiveField(7)
  String? time;
  @HiveField(8)
  String? latitude;
  @HiveField(9)
  String? longitude;
  @HiveField(10)
  bool shopUploaded;
  @HiveField(11)
  List image;
  @HiveField(12)
  bool withOutShop;
  @HiveField(13)
  String? syncId;
  @HiveField(14)
  CreateReminder? createReminder;

  CreateVisit({
    this.shop,
    this.reason,
    required this.type,
    required this.remarks,
    this.phone,
    this.name,
    this.time,
    this.shopUploaded = true,
    this.latitude,
    this.longitude,
    required this.image,
    this.withOutShop = false,
    this.syncId,
    this.createReminder,
  });
}
