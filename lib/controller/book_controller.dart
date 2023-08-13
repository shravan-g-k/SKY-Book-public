import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:journalbot/common/widgets/error_dialog.dart';
import 'package:journalbot/model/book_model.dart';
import 'package:journalbot/repository/auth_repo.dart';
import 'package:journalbot/repository/book_repo.dart';

// bookControllerProvider is a provider used to create an instance of BookController
final bookControllerProvider = Provider((ref) => BookController(ref));

// BookController responsible for all the error handling and calling the repository methods
class BookController {
  final Ref _ref;

  BookController(this._ref);

// Create a book
// Return Book object
// Takes String title, description, icon, token as arguments
  void createBook({
    required String title,
    required String description,
    required String icon,
    required String token,
    required BuildContext context,
  }) async {
    try {
      // Call the createBook method in the BookRepository
      Book book = await _ref.read(bookRepositoryProvider).createBook(
          title: title, description: description, icon: icon, token: token);
      // Update the userProvider state
      _ref.read(userProvider.notifier).update((state) {
        state!.books.add(book.id);
        return state;
      });
      // Update the booksProvider state
      _ref.read(booksProvider.notifier).addBook(book);
      if (context.mounted) {
        context.pop();
      }
      Fluttertoast.showToast(
        msg: "Book created successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      errorDialog(
        context: context,
        title: 'Something went wrong',
        content: 'Error creating book',
      );
    }
  }

// Update a book
// Return Book object
// Takes String title, description, icon, token as arguments
  void updateBook({
    required BuildContext context,
    required Book book,
  }) async {
    try {
      final token = _ref.read(userProvider)!.token;
      // Call the updateBook method in the BookRepository
      Book updatedBook = await _ref.read(bookRepositoryProvider).updateBook(
            book: book,
            token: token,
          );
      // Update the booksProvider state
      _ref.read(booksProvider.notifier).updateBook(updatedBook);
      // Show a toast message
      Fluttertoast.showToast(
        msg: "Book updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      errorDialog(
        context: context,
        title: 'Something went wrong',
        content: 'Error updating book',
      );
    }
  }
}
