import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skybook/const.dart';

import '../model/book_model.dart';
import 'auth_repo.dart';

// bookRepositoryProvider is a provider used to create an instance of BookRepository
final bookRepositoryProvider = Provider((ref) => BookRepository());

final futureBookProvider = FutureProvider<List<Book>>((ref) async {
  final user = ref.read(userProvider)!;
  final books =
      await ref.read(bookRepositoryProvider).getBooks(user.token, user.id);
  ref.read(booksProvider.notifier).intializeBooks(books);
  return books;
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
  Future<List<Book>> getBooks(String token, String userId) async {
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
      if (data[i]['password'] != null) {
        // Create a key and iv for decryption
        final key = Key.fromUtf8(userId);
        final iv = IV.fromLength(16);
        final encrypter = Encrypter(AES(key));
        // Decrypt the password
        final decodedPassword =
            encrypter.decrypt64(data[i]['password'], iv: iv).toString();
        data[i]['password'] = decodedPassword;
      }
      books.insert(0, Book.fromMap(data[i]));
    }
    // Return the list of Book objects
    return books;
  }

// updateBook makes a PUT request to the server to update the book
// Returns the new updated Book object
// Takes Book book, String token as arguments
  Future<Book> updateBook({
    required Book book,
    required String token,
    required String userId,
  }) async {
    // Uri of the server
    Uri url = Uri.parse('$serverAddress/book/update');
    String? encryptedPassword;
    // Encrypt the password
    if (book.password != null) {
      // Create a key and iv for encryption
      final key = Key.fromUtf8(userId);
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(key));
      encryptedPassword =
          encrypter.encrypt(book.password.toString(), iv: iv).base64;
    }

    // Send a PUT request to the server
    final response = await http.put(url,
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'bookId': book.id,
          'bookTitle': book.title,
          'bookDescription': book.description,
          'bookIcon': book.icon,
          'bookPassword': encryptedPassword,
        }));
    // Decode the response body
    Map<String, dynamic> data = jsonDecode(response.body);
    String decodedPassword = '';
    late Book newBook;
    // Decrypt the password
    if (data['password'] != null) {
      // Create a key and iv for decryption
      final key = Key.fromUtf8(userId);
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(key));
      decodedPassword =
          encrypter.decrypt64(data['password'], iv: iv).toString();
      newBook = Book(
        title: data['title'],
        description: data['description'],
        icon: data['icon'],
        id: data['_id'],
        pages: List<String>.from(data['pages']),
        password: decodedPassword,
      );
    } else {
      newBook = Book.fromMap(data);
    }
    // Return the Book object
    return newBook;
  }

// deleteBook makes a DELETE request to the server to delete the book
// Returns the nothing
// Takes Book book, String token as arguments
  Future<void> deleteBook({
    required String bookId,
    required String token,
  }) async {
    // Uri of the server
    Uri url = Uri.parse('$serverAddress/book/delete');
    // Send a DELETE request to the server
    await http.delete(
      url,
      headers: {
        'x-auth-token': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'bookId': bookId,
      }),
    );
  }
}
