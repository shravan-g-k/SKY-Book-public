import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/common/widgets/loading.dart';
import 'package:skybook/const.dart';
import 'package:skybook/model/page_model.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/repository/book_repo.dart';
import 'package:http/http.dart' as http;

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
      // Show a loading dialog
      showDialog(
        context: context,
        builder: (context) => const Center(child: Loader()),
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
        navigator.pop(); // Pop the loading dialog
        return value;
      });
      // Add the page to the book this updates the UI as well from x pages to x+1 pages
      _ref.read(booksProvider.notifier).addPage(bookId, page.id);
      // Add page to the pagesProvider updating the UI
      _ref.read(pagesProvider.notifier).addPage(page);
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

  Future<bool?> getPages(String bookId, {int? from}) async {
    try {
      final user = _ref.read(userProvider)!;
      final pages = await _ref.read(pageRepositoryProvider).getPages(
          token: user.token, bookId: bookId, userId: user.id, from: from);
      if (pages.isEmpty) {
        return false;
      }
      _ref.read(pagesProvider.notifier).addPages(pages);
      return true;
    } catch (e) {
      // No error handling
    }
    return null;
  }

  // Update a page
  // Takes in the PageModel and context
  // Calls the updatePage method from the PageRepository class
  // Calls the updatePage method from the pagesProvider
  Future<void> updatePage({
    required PageModel pageModel,
    required BuildContext context,
    bool showToast = true,
  }) async {
    final user = _ref.read(userProvider)!; // Get the user to get the token
    try {
      // Update a page
      PageModel page = await _ref.read(pageRepositoryProvider).updatePage(
          title: pageModel.title,
          icon: pageModel.icon,
          data: pageModel.data,
          updatedAt: pageModel.updatedAt,
          createdAt: pageModel.createdAt,
          userId: user.id,
          token: user.token,
          pageId: pageModel.id,
          publicPageId: pageModel.publicPageId);
      // Update the page in the pagesProvider updating the UI
      _ref.read(pagesProvider.notifier).updatePage(page);
    } catch (e) {
      if (showToast) {
        Fluttertoast.showToast(
          msg: "Couldn't auto save",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  // Delete a page
  // Takes in the pageId, bookId and context
  // Calls the deletePage method from the PageRepository class

  Future<void> deletePage({
    required String pageId,
    required String bookId,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!; // Get the user to get the token
    final navigator = GoRouter.of(context);
    try {
      // Delete a page
      await _ref.read(pageRepositoryProvider).deletePage(
            token: user.token,
            bookId: bookId,
            pageId: pageId,
          );
      // Delete the page from the pagesProvider updating the UI
      _ref.read(pagesProvider.notifier).deletePage(pageId);
      // Delete the page from the book this updates the UI as well from x pages to x-1 pages
      _ref.read(booksProvider.notifier).deletePage(bookId, pageId);

      // Show a toast
      Fluttertoast.showToast(
        msg: "Page deleted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      navigator.pop();
    } catch (e) {
      errorDialog(
        context: context,
        title: 'Something went wrong',
        content: 'Error deleting page',
      );
    }
  }
}

// Takes in a list of user messages and returns the next AI message
// If AI has an error it returns null
Future<String?> getAIMessage(List<String> messages) async {
  final url = Uri.parse("$serverAddress/generate");
  final response = await http.post(url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({
        'messages': messages,
      }));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return null;
  }
}
