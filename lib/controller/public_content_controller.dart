import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/common/widgets/error_dialog.dart';
import 'package:skybook/controller/page_controller.dart';
import 'package:skybook/model/page_model.dart';
import 'package:skybook/model/public_page_model.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/repository/public_content_repo.dart';


final publicContentControllerProvider =
    Provider((ref) => PublicContentController(ref));

class PublicContentController {
  final Ref _ref;

  PublicContentController(this._ref);


  Future<int> getPageLikes(String publicPageId) async {
    try {
      final likes = await _ref
          .read(publicPageRepositoryProvider)
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
          .read(publicPageRepositoryProvider)
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
