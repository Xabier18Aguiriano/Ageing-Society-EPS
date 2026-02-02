class User {
  String name;
  String age;
  String country;

  User({
    this.name = '',
    this.age = '',
    this.country = '',
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'country': country,
      };

  // Crear desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      age: json['age'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
