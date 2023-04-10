import 'package:hive/hive.dart';
part 'image_model.g.dart';

@HiveType(typeId: 36)
class ImageModel {
  @HiveField(0)
  String? visitId;
  @HiveField(1)
  String? shopId;
  @HiveField(2)
  String imagePath;
  @HiveField(3)
  String? syncId;

  ImageModel({
    required this.imagePath,
    this.shopId,
    this.visitId,
    this.syncId,
  });
}
