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
}
