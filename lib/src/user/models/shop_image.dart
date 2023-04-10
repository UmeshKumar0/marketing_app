class ShopImage {
  String? sId;
  String? url;
  bool? uploaded;
  String? thumbnailUrl;
  String? visitId;
  int? iV;

  ShopImage({
    this.sId,
    this.url,
    this.uploaded,
    this.thumbnailUrl,
    this.visitId,
    this.iV,
  });

  ShopImage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    url = json['url'];
    uploaded = json['uploaded'];
    thumbnailUrl = json['thumbnailUrl'];
    visitId = json['visitId'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['url'] = url;
    data['uploaded'] = uploaded;
    data['thumbnailUrl'] = thumbnailUrl;
    data['visitId'] = visitId;
    data['__v'] = iV;
    return data;
  }
}
