import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/utils/routes.dart';
import 'package:skybook/common/widgets/error_dialog.dart';
import '../common/widgets/loading.dart';
import '../repository/auth_repo.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

// This is the controller class for the AuthRepository
class AuthController {
  final Ref _ref;
  AuthController(this._ref);

// Sign in with Google - success updates userProvider navigates to HomeScreen, failure shows error dialog
  void signInWithGoogle(BuildContext context) {
    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(child: Loader()),
    );
    _ref.read(authRepositoryProvider).signInWithGoogle().then((value) {
      _ref.read(userProvider.notifier).update((state) => value);
      context.pushReplacementNamed(MyRouter.homeRoute);
    }).catchError((e) {
      errorDialog(context: context, content: "Sign in failed");
    });
  }

// Sign out - success navigates to AuthScreen, failure shows error dialog
  void signOut(BuildContext context) {
    _ref.read(authRepositoryProvider).signOut().then((value) {
      context.pushReplacementNamed(MyRouter.authRoute);
    }).catchError((e) {
      errorDialog(context: context, content: "Sign out failed");
    });
  }
}
