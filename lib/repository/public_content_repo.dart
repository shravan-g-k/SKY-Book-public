import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../model/public_book_model.dart';
import '../model/public_page_model.dart';

final publicContentRepositoryProvider =
    Provider((ref) => PublicContentRepository());

class PublicContentRepository {
  Future<PublicBook> createPublicBook({
    required String title,
    required String description,
    required String icon,
    required List<String> pages,
    required String creator,
    required String token,
  }) async {
    final url = Uri.parse('$serverAddress/publicbook/create');
    final body = {
      'title': title,
      'description': description,
      'icon': icon,
      'pages': pages,
      'creator': creator,
    };
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'x-auth-token': token,
        'Content-Type': 'application/json',
      },
    );
    final responseBody = jsonDecode(response.body);
    final publicBook = PublicBook.fromMap(responseBody);
    return publicBook;
  }

  Future<int> getLikesCount(String publicBookId) async {
    final url = Uri.parse('$serverAddress/publicbook/$publicBookId/likes');
    final response = await http.get(url);
    final responseBody = jsonDecode(response.body);
    return responseBody;
  }

  Future<PublicPage> createPublicPage({
    required String title,
    required String icon,
    required String creator,
    required String data,
    required String token,
  }) async {
    final url = Uri.parse('$serverAddress/publicpage/create');
    final body = {
      'title': title,
      'icon': icon,
      'creator': creator,
      'data': data,
    };
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'x-auth-token': token,
        'Content-Type': 'application/json',
      },
    );
    final responseBody = jsonDecode(response.body);
    final publicPage = PublicPage.fromMap(responseBody);
    return publicPage;
  }

  Future<int> getPageLikes({
    required String publicPageId,
  }) async {
    final url = Uri.parse('$serverAddress/publicpage/$publicPageId/likes');
    final response = await http.get(url);
    final responseBody = jsonDecode(response.body);
    return responseBody;

  }


}
