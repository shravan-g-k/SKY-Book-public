import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skybook/const.dart';
import 'package:http/http.dart' as http;
import 'package:skybook/model/page_model.dart';

import 'auth_repo.dart';

// Provider for PageRepository
final pageRepositoryProvider = Provider((ref) => PageRepository());

final futurePagesProvider = FutureProvider.autoDispose
    .family<List<PageModel>, String>((ref, bookId) async {
  final user = ref.read(userProvider)!;
  final pages = await ref
      .read(pageRepositoryProvider)
      .getPages(token: user.token, bookId: bookId, userId: user.id);
  ref.read(pagesProvider.notifier).initializePages(pages);
  return pages;
});

final pagesProvider = StateNotifierProvider<PageNotifier, List<PageModel>>(
  (ref) => PageNotifier(),
);

// PageRepository class contains all the logic for creating a page
class PageRepository {
  // Create a page
  // It encrypts the page data and sends it to the server
  // recieves the encrypted data and decrypts it again
  // returns the page
  Future<PageModel> createPage({
    required String title,
    required String icon,
    required String data,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
    required String bookId,
    required String token,
  }) async {
    // Create a key and iv for encryption
    final key = Key.fromUtf8(userId);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    // Encrypt the page data
    final encrypted = encrypter
        .encrypt(
          jsonEncode({
            'title': title,
            'icon': icon,
            'data': data,
            'createdAt': createdAt.millisecondsSinceEpoch,
            'updatedAt': updatedAt.millisecondsSinceEpoch,
          }),
          iv: iv,
        )
        .base64; // convert to base64 (string)
    final url =
        Uri.parse('$serverAddress/page/create'); // url for creating a page
    // Send the encrypted data to the server
    final response = await http.post(url,
        body: jsonEncode({
          'bookId': bookId,
          'encoded': encrypted,
        }),
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json',
        });
    // Decode the response
    final Map<String, dynamic> json = jsonDecode(response.body);
    final decodedPage = encrypter.decrypt64(json['encoded'], iv: iv);
    // Create a page from the decoded response
    final page = PageModel.fromMap({
      ...jsonDecode(decodedPage),
      'id': json['_id'],
    });
    return page;
  }

  // Get all the pages of a book
  // Returns a list of PageModel objects
  // Takes String token, String bookId as arguments and int from as optional argument
  // from is the index of the first page to get (used for pagination)
  // server returns 30 encrypted pages at a time which are decrypted here
  Future<List<PageModel>> getPages({
    required String token,
    required String bookId,
    required String userId,
    int? from,
  }) async {
    // Uri of the server
    final url = Uri.parse('$serverAddress/pages');
    // Send a GET request to the server
    final response = await http.get(url, headers: {
      'x-auth-token': token,
      'Content-Type': 'application/json',
      'bookId': bookId,
      if (from != null) 'from': from.toString(),
    });
    // Decode the response body
    final List<dynamic> data = jsonDecode(response.body);
    // Create a list of PageModel objects
    final List<PageModel> pages = [];
    // Create a key and iv for decryption
    final key = Key.fromUtf8(userId);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    // Add each page to the list
    for (var i = 0; i < data.length; i++) {
      // Decrypt the page data
      final decodedPage = encrypter.decrypt64(data[i]['encoded'], iv: iv);
      // Create a PageModel object
      final page = PageModel.fromMap({
        ...jsonDecode(decodedPage),
        'id': data[i]['_id'],
      });
      // Add the page to the list
      pages.add(page);
    }
    // Return the list of PageModel objects
    return pages;
  }

  // Update a page
  // It encrypts the page data and sends it to the server
  // recieves the encrypted data and decrypts it again
  // returns the page
  Future<PageModel> updatePage({
    required String pageId,
    required String title,
    required String icon,
    required String data,
    required DateTime updatedAt,
    required DateTime createdAt,
    required String userId,
    required String token,
  }) async {
    // Create a key and iv for encryption
    final key = Key.fromUtf8(userId);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    // Encrypt the page data
    final encrypted = encrypter
        .encrypt(
          jsonEncode({
            'title': title,
            'icon': icon,
            'data': data,
            'updatedAt': updatedAt.millisecondsSinceEpoch,
            'createdAt': createdAt.millisecondsSinceEpoch,
          }),
          iv: iv,
        )
        .base64; // convert to base64 (string)
    final url =
        Uri.parse('$serverAddress/page/update'); // url for updating a page
    // Send the encrypted data to the server
    final response = await http.put(url,
        body: jsonEncode({
          'pageId': pageId,
          'encoded': encrypted,
        }),
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json',
        });
    // Decode the response
    final Map<String, dynamic> json = jsonDecode(response.body);
    final decodedPage = encrypter.decrypt64(json['encoded'], iv: iv);
    // Create a page from the decoded response
    final page = PageModel.fromJson(
      jsonEncode({
        ...jsonDecode(decodedPage),
        'id': json['_id'],
      }),
    );
    return page;
  }

  // Delete a page
  // Takes String pageId, bookId String token as arguments
  Future<void> deletePage({
    required String pageId,
    required String bookId,
    required String token,
  }) async {
    // Uri of the server
    final url = Uri.parse('$serverAddress/page/delete');
    // Send a DELETE request to the server
    await http.delete(
      url,
      headers: {
        'x-auth-token': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'pageId': pageId,
        'bookId': bookId,
      }),
    );
  }
}
