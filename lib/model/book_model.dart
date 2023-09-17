import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Book {
  String title;
  String description;
  String icon;
  String id;
  List<String> pages;
  String? password;
  int? likes;
  Book({
    required this.title,
    required this.description,
    required this.icon,
    required this.id,
    required this.pages,
    this.password,
    this.likes,
  });

  Book copyWith({
    String? title,
    String? description,
    String? icon,
    String? id,
    List<String>? pages,
    String? password,
    int? likes,
  }) {
    return Book(
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      pages: pages ?? this.pages,
      password: password ?? this.password,
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
      'password': password,
      'likes': likes,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      id: map['_id'] ?? '',
      pages: List<String>.from(map['pages']),
      password: map['password'],
      likes: map['likes']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) => Book.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Book(title: $title, description: $description, icon: $icon, id: $id, pages: $pages, password: $password, likes: $likes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book &&
        other.title == title &&
        other.description == description &&
        other.icon == icon &&
        other.id == id &&
        listEquals(other.pages, pages) &&
        other.password == password &&
        other.likes == likes;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        id.hashCode ^
        pages.hashCode ^
        password.hashCode ^
        likes.hashCode;
  }
}

class UserBooksNotifier extends StateNotifier<List<Book>> {
  UserBooksNotifier() : super([]);
  void intializeBooks(List<Book> books) {
    state = books;
  }

  void addBook(Book book) {
    state = [book, ...state];
  }

  void updateBook(Book book) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (state[i].id == book.id) book else state[i]
    ];
  }

  void addPage(String bookId, String pageId) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (state[i].id == bookId)
          state[i].copyWith(pages: [...state[i].pages, pageId])
        else
          state[i]
    ];
  }

  void deletePage(String bookId, String pageId) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (state[i].id == bookId)
          state[i].copyWith(pages: [
            for (var j = 0; j < state[i].pages.length; j++)
              if (state[i].pages[j] != pageId) state[i].pages[j]
          ])
        else
          state[i]
    ];
  }

  void deleteBook(String bookId) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (state[i].id != bookId) state[i]
    ];
  }
}
