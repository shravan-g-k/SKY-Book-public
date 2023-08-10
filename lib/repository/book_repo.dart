import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:journalbot/const.dart';

import '../model/book_model.dart';
import 'auth_repo.dart';

// bookRepositoryProvider is a provider used to create an instance of BookRepository
final bookRepositoryProvider = Provider((ref) => BookRepository());

final futureBookProvider = FutureProvider((ref) async {
  final token = ref.read(userProvider)!.token;
  final books = await ref.read(bookRepositoryProvider).getBooks(token);
  ref.read(booksProvider.notifier).intializeBooks(books);
});
// booksProvider is a NotifierProvider used to create an instance of List<Book>?
final booksProvider = StateNotifierProvider<UserBooksNotifier, List<Book>?>(
    (ref) => UserBooksNotifier());

// BookRepository responsible for all the CRUD operations related to the Book model
// Methods - createBook
class BookRepository {
  // Create a book
  // Return Book object
  // Takes String title, description, icon, token as arguments
  // No error handling - done in the controller
  Future<Book> createBook({
    required String title,
    required String description,
    required String icon,
    required String token,
  }) async {
    // Uri of the server
    Uri url = Uri.parse('$serverAddress/book/create');
    // Send a POST request to the server
    final response = await http.post(url,
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'bookTitle': title,
          'bookDescription': description,
          'bookIcon': icon,
        }));
    // Decode the response body
    Map<String, dynamic> data = jsonDecode(response.body);
    Book book = Book.fromMap(data);
    // Return the Book object
    return book;
  }

  // Get all the books of the user
  // Return List<Book> object
  // Takes String token as argument
  // No error handling - done in the controller
  Future<List<Book>> getBooks(String token) async {
    // Uri of the server
    Uri url = Uri.parse('$serverAddress/book/all');
    // Send a GET request to the server
    final response = await http.get(url, headers: {
      'x-auth-token': token,
    });
    // Decode the response body
    List<dynamic> data = jsonDecode(response.body);
    // Create a list of Book objects
    List<Book> books = [];
    // Add each book to the list
    for (var i = 0; i < data.length; i++) {
      books.add(Book.fromMap(data[i]));
    }
    // Return the list of Book objects
    return books;
  }
}
