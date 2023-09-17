import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skybook/common/widgets/error_dialog.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/repository/public_book_repo.dart';

final publicBookControllerProvider =
    Provider((ref) => PublicBookController(ref));

class PublicBookController {
  final Ref _ref;

  PublicBookController(this._ref);
  void createPublicBook({
    required String title,
    required String description,
    required String icon,
    required List<String> pages,
    required String creator,
    required BuildContext context,
  }) async {
    try {
      final token = _ref.read(userProvider)!.token;
      await _ref
          .read(publicBookRepositoryProvider)
          .createPublicBook(
            title: title,
            description: description,
            icon: icon,
            pages: pages,
            token: token,
            creator: creator,
          )
          .then((value) {
        // pop the dialog
        Navigator.of(context).pop();
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
}
