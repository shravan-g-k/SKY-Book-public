import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/common/widgets/error_dialog.dart';
import 'package:skybook/controller/book_controller.dart';
import 'package:skybook/controller/page_controller.dart';
import 'package:skybook/model/page_model.dart';
import 'package:skybook/model/public_page_model.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/repository/public_content_repo.dart';

import '../model/book_model.dart';

final publicContentControllerProvider =
    Provider((ref) => PublicContentController(ref));

class PublicContentController {
  final Ref _ref;

  PublicContentController(this._ref);
  void createPublicBook({
    required Book book,
    required String creator,
    required BuildContext context,
  }) async {
    try {
      final token = _ref.read(userProvider)!.token;
      await _ref
          .read(publicContentRepositoryProvider)
          .createPublicBook(
            title: book.title,
            description: book.description,
            icon: book.icon,
            pages: book.pages,
            token: token,
            creator: creator,
          )
          .then((value) {
        // pop the dialog
        Navigator.of(context).pop();
        _ref.read(bookControllerProvider).updateBook(
              context: context,
              book: book.copyWith(publicBookId: value.id),
              showToast: false,
            );
      });

      Fluttertoast.showToast(
        msg: "Book published successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      errorDialog(
        context: context,
        title: 'Failed to publish',
        content: 'Try again later',
      );
    }
  }

  Future<int> getBookLikes(String publicBookId) async {
    try {
      final likes = await _ref
          .read(publicContentRepositoryProvider)
          .getBookLikes(publicBookId);
      return likes;
    } catch (e) {
      return 0;
    }
  }
  Future<int> getPageLikes(String publicPageId) async {
    try {
      final likes = await _ref
          .read(publicContentRepositoryProvider)
          .getPageLikes(publicPageId);
      return likes;
    } catch (e) {
      return 0;
    }
  }

  

  Future<PublicPage?> createPublicPage({
    required PageModel page,
    required BuildContext context,
  }) async {
    try {
      final user = _ref.read(userProvider)!;
      final publicPage = await _ref
          .read(publicContentRepositoryProvider)
          .createPublicPage(
            title: page.title,
            data: page.data,
            icon: page.icon,
            token: user.token,
            creator: user.name,
          )
          .then((value) {
        _ref.read(pageControllerProvider).updatePage(
              pageModel: page.copyWith(publicPageId: value.id),
              context: context,
            );

        context.pop();
        Fluttertoast.showToast(
          msg: "Page published successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return value;
      });
      return publicPage;
    } catch (e) {
      errorDialog(
        context: context,
        title: "Couldn't publish page",
      );
      return null;
    }
  }
}
