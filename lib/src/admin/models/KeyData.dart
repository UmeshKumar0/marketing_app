class KeyData {
  String? sId;
  String? key;
  String? value;

  KeyData({this.sId, this.key, this.value});

  KeyData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
