import 'dart:convert';

class AppUser {
  final String name;
  final String email;
  final String id;
  final String token;
  AppUser({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'token': token,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['_id'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(name: $name, email: $email, id: $id, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.name == name &&
        other.email == email &&
        other.id == id &&
        other.token == token;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ id.hashCode ^ token.hashCode;
  }
}
