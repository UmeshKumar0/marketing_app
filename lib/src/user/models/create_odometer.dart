import 'package:hive/hive.dart';
import 'package:marketing/src/user/models/index.dart';
part 'create_odometer.g.dart';

@HiveType(typeId: 27)
class CreateOdometerModel {
  @HiveField(0)
  final String? reading;
  @HiveField(1)
  final LatLong? coordinate;
  @HiveField(2)
  final String? imgPath;
  @HiveField(3)
  final bool completed;
  @HiveField(4)
  final bool isAbsent;
  @HiveField(5)
  final String? address;
  @HiveField(6)
  final String? time;

  CreateOdometerModel({
    this.reading,
    this.coordinate,
    this.imgPath,
    this.completed = false,
    this.isAbsent = false,
    this.address,
    this.time,
  });
}
