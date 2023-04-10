class ReportGraph {
  List<Item>? today;
  List<Item>? week;
  List<Item>? month;
  List<Item>? year;

  ReportGraph({this.today, this.week, this.month, this.year});

  ReportGraph.fromJson(Map<String, dynamic> json) {
    if (json['today'] != null) {
      today = <Item>[];
      json['today'].forEach((v) {
        today!.add(Item.fromJson(v));
      });
    }
    if (json['week'] != null) {
      week = <Item>[];
      json['week'].forEach((v) {
        week!.add(Item.fromJson(v));
      });
    }
    if (json['month'] != null) {
      month = <Item>[];
      json['month'].forEach((v) {
        month!.add(Item.fromJson(v));
      });
    }
    if (json['year'] != null) {
      year = <Item>[];
      json['year'].forEach((v) {
        year!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (today != null) {
      data['today'] = today!.map((v) => v.toJson()).toList();
    }
    if (week != null) {
      data['week'] = week!.map((v) => v.toJson()).toList();
    }
    if (month != null) {
      data['month'] = month!.map((v) => v.toJson()).toList();
    }
    if (year != null) {
      data['year'] = year!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String? sId;
  int? count;

  Item({this.sId, this.count});

  Item.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['count'] = count;
    return data;
  }
}
