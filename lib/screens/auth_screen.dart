import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

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
    // SCAFFOLD with background color and centered column
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          // COLUMN with Journal Bot title, welcome message, and sign in button
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/sky-logo.png',
                height: 100,
              ),

              // SKY BOOK title
              const Text(
                'SKY Book',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 10),
              // PLEASE SIGN IN message
              const Text(
                'Please sign in to continue.',
              ),
              const SizedBox(height: 16),
              // SIGN IN WITH GOOGLE button
              ElevatedButton(
                // ButtonStyle - minimumSize, backgroundColor, shape
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 40)),
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
                    color: Theme.of(context).colorScheme.onPrimary,
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
