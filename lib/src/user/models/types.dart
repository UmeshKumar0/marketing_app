
import 'package:hive/hive.dart';
part 'types.g.dart';

@HiveType(typeId: 31)
class VisitType {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? value;

  VisitType({this.sId, this.value});

  VisitType.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['value'] = value;
    return data;
  }
}