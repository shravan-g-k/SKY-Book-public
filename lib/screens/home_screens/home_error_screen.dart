import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/common_text_styles.dart';
import '../../controller/auth_controller.dart';
import '../../utils/theme.dart';

class HomeErrorScreen extends ConsumerWidget {
  const HomeErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Something unexpected happened",
              style : titleTextStyle(theme, fontSize: 20)
            ),
            Text(
              "Please try logging in again",
              style: titleTextStyle(theme, fontSize: 20)
            ),
            OutlinedButton(
              onPressed: () {
                ref.read(authControllerProvider).signOut(context);
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
