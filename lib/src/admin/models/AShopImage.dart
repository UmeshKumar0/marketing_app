class AShopImage {
  String? sId;
  String? url;
  bool? uploaded;
  String? thumbnailUrl;
  String? visitId;
  String? shopId;
  String? createdAt;

  AShopImage(
      {this.sId,
      this.url,
      this.uploaded,
      this.thumbnailUrl,
      this.visitId,
      this.shopId,
      this.createdAt});

  AShopImage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    url = json['url'];
    uploaded = json['uploaded'];
    thumbnailUrl = json['thumbnailUrl'];
    visitId = json['visitId'];
    shopId = json['shopId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['url'] = url;
    data['uploaded'] = uploaded;
    data['thumbnailUrl'] = thumbnailUrl;
    data['visitId'] = visitId;
    data['shopId'] = shopId;
    data['createdAt'] = createdAt;
    return data;
  }
}
