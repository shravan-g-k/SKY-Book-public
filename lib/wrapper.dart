import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/const.dart';
import 'package:journalbot/screens/auth_screen.dart';
import 'package:journalbot/screens/home_page.dart';
import 'package:journalbot/utils/error_screen.dart';
import 'package:journalbot/utils/splash_screen.dart';
import 'package:journalbot/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  late Future<SharedPreferences> sharedPreferences;
  @override
  void initState() {
    // Get the shared preferences to fetch the thememode
    sharedPreferences = SharedPreferences.getInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MyTheme theme = ref.read(themeProvider);
          // Initialize the theme provider with the users theme mode(if present)
          theme.init(snapshot.data!);
          String? token = snapshot.data!.getString(tokenKey);
          if (token == null) {
            return const AuthScreen();
          } else {
            return const HomeScreen();
          }
        } else if (snapshot.hasError) {
          return const ErrorScreen();
        } else {
          return const SplashScreen();
        }
      },
      future: sharedPreferences,
    );
  }
}
