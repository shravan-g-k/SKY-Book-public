import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/screens/auth_screen.dart';
import 'package:journalbot/screens/home_page.dart';
import 'package:journalbot/utils/error_dialog.dart';
import 'package:journalbot/utils/theme.dart';
import '../repository/auth_repo.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

// This is the controller class for the AuthRepository
class AuthController {
  final Ref _ref;
  AuthController(this._ref);

// Sign in with Google - success navigates to HomeScreen, failure shows error dialog
  void signInWithGoogle(BuildContext context, MyTheme theme) {
    _ref
        .read(authRepositoryProvider)
        .signInWithGoogle()
        // TODO : change to RouteMaster
        .then((value) => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreen(theme))))
        .catchError(
          (e) => errorDialog(
              context: context, theme: theme, content: "Sign in failed"),
        );
  }

// Sign out - success navigates to AuthScreen, failure shows error dialog
  void signOut(BuildContext context, MyTheme theme) {
    _ref
        .read(authRepositoryProvider)
        .signOut()
        // TODO : change to RouteMaster
        .then((value) => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AuthScreen(theme))))
        .catchError(
          (e) => errorDialog(
              context: context, theme: theme, content: "Sign out failed"),
        );
  }
}
