import 'package:hive/hive.dart';
part 'rtlLocation_model.g.dart';

@HiveType(typeId: 87)
class RTLocation {
  @HiveField(0)
  String userId;
  @HiveField(1)
  double lat;
  @HiveField(2)
  double lng;
  @HiveField(3)
  int time = DateTime.now().millisecondsSinceEpoch;

  RTLocation({
    required this.userId,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'lat': lat,
      'lng': lng,
      'time': time,
    };
  }
}
