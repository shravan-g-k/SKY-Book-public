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
    print(responseBody);
    return responseBody;
  }

  Future<List<PublicBook>> getPublicBooks({int next = 0}) async {
    final url = Uri.parse('$serverAddress/publicbook');
    final response = await http.get(url, headers: {
      'next': next.toString(),
      'Content-Type': 'application/json',
    });
    final responseBody = jsonDecode(response.body);
    final List<PublicBook> publicBooks = [];
    for (var i = 0; i < responseBody.length; i++) {
      publicBooks.insert(0, PublicBook.fromMap(responseBody[i]));
    }
    return publicBooks;
  }

  Future<List<PublicPage>> getPublicPages({int next = 0}) async {
    final url = Uri.parse('$serverAddress/publicpage');
    final response = await http.get(url, headers: {
      'next': next.toString(),
      'Content-Type': 'application/json',
    });
    final responseBody = jsonDecode(response.body);
    final List<PublicPage> publicPages = [];
    for (var i = 0; i < responseBody.length; i++) {
      publicPages.insert(0, PublicPage.fromMap(responseBody[i]));
    }
    return publicPages;
  }

  Future<List<dynamic>> getPagesAndBooks({int next = 0}) async {
    List<PublicBook> publicBooks = await getPublicBooks(next: next);
    List<PublicPage> publicPages = await getPublicPages(next: next);
    List<dynamic> publicContent = [];
    publicContent.addAll(publicBooks);
    publicContent.addAll(publicPages);
    publicContent.shuffle();
    return publicContent;
  }

  void likePublicBook({
    required String publicBookId,
    required String token,
  }) async {
    final url = Uri.parse('$serverAddress/publicbook/$publicBookId/likes');
    await http.put(
      url,
      headers: {
        'x-auth-token': token,
        'Content-Type': 'application/json',
      },
    );
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
