import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth_controller.dart';

class HomeErrorScreen extends ConsumerWidget {
  const HomeErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Something unexpected happened",
            ),
            const Text(
              "Please try logging in again",
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
