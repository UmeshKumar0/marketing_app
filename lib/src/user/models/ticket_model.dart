class TicketModel {
  String? sId;
  String? title;
  String? description;
  List<String>? images;
  List<String>? voicenotes;
  String? userId;
  bool? resolved;

  TicketModel(
      {this.sId,
      this.title,
      this.description,
      this.images,
      this.voicenotes,
      this.userId,
      this.resolved});

  TicketModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    images = json['images'].cast<String>();
    voicenotes = json['voicenotes'].cast<String>();
    userId = json['userId'];
    resolved = json['resolved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['images'] = images;
    data['voicenotes'] = voicenotes;
    data['userId'] = userId;
    data['resolved'] = resolved;
    return data;
  }
}
