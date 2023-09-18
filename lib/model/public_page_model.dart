import 'dart:convert';

class PublicPage {
  final String id;
  final String title;
  final String icon;
  final String data;
  int likes;
  final String creator;
  PublicPage({
    required this.id,
    required this.title,
    required this.icon,
    required this.data,
    required this.likes,
    required this.creator,
  });

  PublicPage copyWith({
    String? id,
    String? title,
    String? icon,
    String? data,
    int? likes,
    String? creator,
  }) {
    return PublicPage(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      data: data ?? this.data,
      likes: likes ?? this.likes,
      creator: creator ?? this.creator,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'data': data,
      'likes': likes,
      'creator': creator,
    };
  }

  factory PublicPage.fromMap(Map<String, dynamic> map) {
    return PublicPage(
      id: map['_id'] ?? '',
      title: map['title'] ?? '',
      icon: map['icon'] ?? '',
      data: map['data'] ?? '',
      likes: map['likes']?.toInt() ?? 0,
      creator: map['creator'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PublicPage.fromJson(String source) =>
      PublicPage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PublicPage(id: $id, title: $title, icon: $icon, data: $data, likes: $likes, creator: $creator)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PublicPage &&
        other.id == id &&
        other.title == title &&
        other.icon == icon &&
        other.data == data &&
        other.likes == likes &&
        other.creator == creator;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        icon.hashCode ^
        data.hashCode ^
        likes.hashCode ^
        creator.hashCode;
  }
}
