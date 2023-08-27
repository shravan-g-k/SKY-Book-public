import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageModel {
  final String id;
  final String title;
  final String icon;
  final String data;
  final DateTime createdAt;
  final DateTime updatedAt;
  PageModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  PageModel copyWith({
    String? id,
    String? title,
    String? icon,
    String? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PageModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'data': data,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory PageModel.fromMap(Map<String, dynamic> map) {
    return PageModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      icon: map['icon'] ?? '',
      data: map['data'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PageModel.fromJson(String source) =>
      PageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PageModel(id: $id, title: $title, icon: $icon, data: $data, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageModel &&
        other.id == id &&
        other.title == title &&
        other.icon == icon &&
        other.data == data &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        icon.hashCode ^
        data.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

class PageNotifier extends StateNotifier<List<PageModel>> {
  PageNotifier() : super([]);

  void initializePages(List<PageModel> pages) {
    state = pages;
  }

  void addPage(PageModel page) {
    state = [page, ...state];
  }
  void addPages(List<PageModel> pages) {
    state = [...state, ...pages];
  }

  void updatePage(PageModel page) {
    state = [
      for (final p in state)
        if (p.id == page.id) page else p,
    ];
  }
}
