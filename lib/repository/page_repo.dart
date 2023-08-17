import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/const.dart';
import 'package:http/http.dart' as http;
import 'package:journalbot/model/page_model.dart';

// Provider for PageRepository
final pageRepositoryProvider = Provider((ref) => PageRepository());

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
}
