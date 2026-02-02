class Sensor {
  final String id;
  final String name;
  bool connected;
  bool active;

  Sensor({
    required this.id,
    required this.name,
    this.connected = false,
    this.active = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'connected': connected,
        'active': active,
      };

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      name: json['name'],
      connected: json['connected'],
      active: json['active'],
    );
  }
}
