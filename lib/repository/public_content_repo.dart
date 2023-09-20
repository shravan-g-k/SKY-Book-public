import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../model/public_page_model.dart';

final publicPageRepositoryProvider = Provider((ref) => PublicPageRepository());

class PublicPageRepository {
  Future<int> getBookLikes(String publicBookId) async {
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

  Future<int> getPageLikes(String publicPageId) async {
    final url = Uri.parse('$serverAddress/publicpage/$publicPageId/likes');
    final response = await http.get(url);
    final responseBody = jsonDecode(response.body);
    return responseBody;
  }

  Future<List<PublicPage>> getPublicPages({int next = 0}) async {
    final url = Uri.parse('$serverAddress/publicpage');
    final response = await http.get(url, headers: {
      'next': (next - 1).toString(),
      'Content-Type': 'application/json',
    });
    final responseBody = jsonDecode(response.body);
    final List<PublicPage> publicPages = [];
    for (var i = 0; i < responseBody.length; i++) {
      publicPages.add(PublicPage.fromMap(responseBody[i]));
    }

    return publicPages;
  }

  void likePublicPage({
    required String publicPageId,
    required String token,
  }) async {
    final url = Uri.parse('$serverAddress/publicpage/$publicPageId/likes');
    await http.put(
      url,
      headers: {
        'x-auth-token': token,
        'Content-Type': 'application/json',
      },
    );
  }
}
