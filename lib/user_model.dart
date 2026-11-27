class User {
  final int id;
  final String name;
  final String email;
  final String city;

  User({required this.id, required this.name, required this.email, required this.city});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: int.tryParse(json['id'].toString()) ?? 0,
    name: json['name']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    city: json['city']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'email': email, 'city': city};
}