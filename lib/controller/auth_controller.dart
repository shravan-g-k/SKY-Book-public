import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  void signInWithGoogle(BuildContext context) {
    final theme = _ref.read(themeProvider);
    _ref
        .read(authRepositoryProvider)
        .signInWithGoogle()
        .then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen())))
        .catchError(
          (e) => errorDialog(
              context: context, theme: theme, content: "Sign in failed"),
        );
  }
}
