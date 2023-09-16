import 'dart:convert';

import 'package:flutter/foundation.dart';

class PublicBook {
  String title;
  String description;
  String icon;
  String id;
  List<String> pages;
  int likes;
  PublicBook({
    required this.title,
    required this.description,
    required this.icon,
    required this.id,
    required this.pages,
    required this.likes,
  });

  PublicBook copyWith({
    String? title,
    String? description,
    String? icon,
    String? id,
    List<String>? pages,
    int? likes,
  }) {
    return PublicBook(
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      pages: pages ?? this.pages,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'id': id,
      'pages': pages,
      'likes': likes,
    };
  }

  factory PublicBook.fromMap(Map<String, dynamic> map) {
    return PublicBook(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      id: map['_id'] ?? '',
      pages: List<String>.from(map['pages']),
      likes: map['likes']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PublicBook.fromJson(String source) =>
      PublicBook.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PublicBook(title: $title, description: $description, icon: $icon, id: $id, pages: $pages, likes: $likes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PublicBook &&
        other.title == title &&
        other.description == description &&
        other.icon == icon &&
        other.id == id &&
        listEquals(other.pages, pages) &&
        other.likes == likes;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        id.hashCode ^
        pages.hashCode ^
        likes.hashCode;
  }
}
