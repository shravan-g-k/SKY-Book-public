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
              textAlign: TextAlign.center,
            ),
            const Text(
              "Please try logging in again",
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              onPressed: () {
                ref.read(authControllerProvider).signOut(context);
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))),
              ),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
