// ignore_for_file: file_names
import 'package:hive/hive.dart';

part 'LatLon.g.dart';

@HiveType(typeId: 28)
class LatLong {
  @HiveField(0)
  final double latitude;
  @HiveField(1)
  final double longitude;

  LatLong({
    required this.longitude,
    required this.latitude,
  });
}
