import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/repository/auth_repo.dart';

import '../controller/auth_controller.dart';
import '../utils/theme.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    MyTheme theme = ref.watch(themeProvider);
    final user = ref.read(userProvider);
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
            Text(
              user.toString(),
              style: TextStyle(
                color: theme.onBackgroundColor,
                fontSize: 12,
              ),
            ),
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
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  ref.read(themeProvider).toggleTheme();
                });
              },
              child: const Text('theme'),
            ),
          ],
        ),
      ),
    );
  }
}
