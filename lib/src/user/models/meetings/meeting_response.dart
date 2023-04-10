class MeetingResponseModel {
  String name;
  String number;
  String from;
  MeetingResponseModel({
    required this.from,
    required this.name,
    required this.number,
  });

  Map<String, String> toJSOn() {
    return {
      "name": name,
      "phone": number,
      "address": from,
    };
  }
}
