import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/common/common_text_styles.dart';

import '../controller/auth_controller.dart';
import '../utils/theme.dart';

// Sign in screen
// Sign in with Google button
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  // Sign in with Google
  void _signInWithGoogle() async {
    // error handling done in AuthController
    ref.read(authControllerProvider).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    // SCAFFOLD with background color and centered column
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          // COLUMN with Journal Bot title, welcome message, and sign in button
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // JOURNAL BOT title
              Text(
                'Journal Bot',
                style: titleTextStyle(theme, fontSize: 50),
              ),
              const SizedBox(height: 16),
              // WELCOME message
              Text(
                'Welcome to Journal Bot!',
                style: titleTextStyle(theme, fontSize: 16),
              ),
              const SizedBox(height: 16),
              // PLEASE SIGN IN message
              Text(
                'Please sign in to continue.',
                style: titleTextStyle(theme, fontSize: 16),
              ),
              const SizedBox(height: 16),
              // SIGN IN WITH GOOGLE button
              ElevatedButton(
                // ButtonStyle - minimumSize, backgroundColor, shape
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 40)),
                  backgroundColor:
                      MaterialStateProperty.all(theme.primaryColor),
                  shape: MaterialStateProperty.all(
                    // this property added bcz material3 forces border radius to be too round
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: _signInWithGoogle,
                // SIGN IN WITH GOOGLE text
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.onPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
