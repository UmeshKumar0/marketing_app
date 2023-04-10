class Sim {
  final int slot;
  final String carrierName;
  final String number;
  final int subsId;

  Sim({
    required this.slot,
    required this.carrierName,
    required this.number,
    required this.subsId,
  });

  factory Sim.fromJson(Map<String, dynamic> json) {
    return Sim(
      slot: json['slot'],
      carrierName: json['carrierName'],
      number: json['number'],
      subsId: json['subsId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slot': slot,
      'carrierName': carrierName,
      'number': number,
      'subsId': subsId,
    };
  }

}
