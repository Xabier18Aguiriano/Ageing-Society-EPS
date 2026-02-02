class FamilyContact {
  final String id;
  String name;
  String phone;
  bool notificationsEnabled;

  FamilyContact({
    required this.id,
    required this.name,
    required this.phone,
    this.notificationsEnabled = true,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'notificationsEnabled': notificationsEnabled,
      };

  // Crear desde JSON
  factory FamilyContact.fromJson(Map<String, dynamic> json) {
    return FamilyContact(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }
}