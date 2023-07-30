import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/theme.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Journal Bot',
                style: TextStyle(
                  color: theme.onBackgroundColor,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Journal Bot!',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.onBackgroundColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please sign in to continue.',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.onBackgroundColor,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 40),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    theme.primaryColor,
                  ),
                ),
                onPressed: () {},
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
