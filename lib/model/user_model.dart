import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppUser {
  final String name;
  final String email;
  final String id;
  final String token;
  final List<String> books;
  AppUser({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
    required this.books,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
    List<String>? books,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
      books: books ?? this.books,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'token': token,
      'books': books,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['_id'] ?? '',
      token: map['token'] ?? '',
      books: List<String>.from(map['books']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(name: $name, email: $email, id: $id, token: $token, books: $books)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppUser &&
      other.name == name &&
      other.email == email &&
      other.id == id &&
      other.token == token &&
      listEquals(other.books, books);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      id.hashCode ^
      token.hashCode ^
      books.hashCode;
  }
}
