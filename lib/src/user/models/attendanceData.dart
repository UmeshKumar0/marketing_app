import 'package:hive/hive.dart';
part 'attendanceData.g.dart';
@HiveType(typeId: 6)
class AttendanceData {
  @HiveField(0)
  Map<String, dynamic> data;
  @HiveField(1)
  String distance;

  AttendanceData({required this.data, required this.distance});
}
