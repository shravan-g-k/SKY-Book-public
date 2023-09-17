import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skybook/common/widgets/error_dialog.dart';
import 'package:skybook/controller/book_controller.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/repository/public_book_repo.dart';

import '../model/book_model.dart';

final publicBookControllerProvider =
    Provider((ref) => PublicBookController(ref));

class PublicBookController {
  final Ref _ref;

  PublicBookController(this._ref);
  void createPublicBook({
    required Book book,
    required String creator,
    required BuildContext context,
  }) async {
    try {
      final token = _ref.read(userProvider)!.token;
      await _ref
          .read(publicBookRepositoryProvider)
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

  Future<int> getLikesCount(String publicBookId) async {
    try {
      final likes = await _ref
          .read(publicBookRepositoryProvider)
          .getLikesCount(publicBookId);
      return likes;
    } catch (e) {
      return 0;
    }
  }
}
