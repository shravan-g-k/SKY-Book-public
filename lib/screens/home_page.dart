import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';
import '../utils/theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen(this.theme, {super.key});
  final MyTheme theme;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home Screen",
              style: TextStyle(
                color: theme.onBackgroundColor,
                fontSize: 50,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                ref.read(authControllerProvider).signOut(context, theme);
              },
              child: const Text('Log Out'),
            )
          ],
        ),
      ),
    );
  }
}
