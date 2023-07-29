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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Journal Bot',
              style: TextStyle(
                color: theme.textColor,
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Journal Bot!',
              style: TextStyle(fontSize: 16, color: theme.textColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Please sign in to continue.',
              style: TextStyle(
                fontSize: 16,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Sign in with Google',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  theme.toggleTheme();
                });
              },
              child:const Text('theme'),
            )
          ],
        ),
      ),
    );
  }
}
