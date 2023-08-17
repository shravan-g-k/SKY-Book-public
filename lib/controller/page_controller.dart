import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:journalbot/common/widgets/loading.dart';
import 'package:journalbot/model/page_model.dart';
import 'package:journalbot/repository/auth_repo.dart';
import 'package:journalbot/repository/book_repo.dart';

import '../common/widgets/error_dialog.dart';
import '../repository/page_repo.dart';

// Provider for PageController
final pageControllerProvider = Provider((ref) => PageController(ref));

// PageController class responsible for creating a page
// Uses the PageRepository class
class PageController {
  final Ref _ref;

  PageController(this._ref);

  // Create a page
  // Takes in the page title, icon, data, createdAt, updatedAt, bookId and context
  // Calls the createPage method from the PageRepository class
  // Calls the addPage method from the booksProvider
  void createPage({
    required String title,
    required String icon,
    required String data,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String bookId,
    required BuildContext context,
  }) async {
    // Get the navigator
    final navigator = GoRouter.of(context);
    final user = _ref.read(userProvider)!; // Get the user to get the token
    try {
      showDialog(
        context: context,
        builder: (context) => const Loader(),
      );
      // Create a page
      PageModel page = await _ref
          .read(pageRepositoryProvider)
          .createPage(
            title: title,
            icon: icon,
            data: data,
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: user.id,
            token: user.token,
            bookId: bookId,
          )
          .then((value) {
        navigator.pop();
        return value;
      });
      // Add the page to the book this updates the UI as well from x pages to x+1 pages
      _ref.read(booksProvider.notifier).addPage(bookId, page.id);
      // Pop the Create Page Dialog
      navigator.pop();
      // Show a toast
      Fluttertoast.showToast(
        msg: "Page created successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
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
}
