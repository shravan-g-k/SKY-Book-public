import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skybook/const.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/screens/auth_screen.dart';
import 'package:skybook/screens/home_screens/home_error_screen.dart';
import 'package:skybook/screens/home_screens/home_screen.dart';
import 'package:skybook/common/pages/error_screen.dart';
import 'package:skybook/common/pages/splash_screen.dart';
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
          // Get the token from the shared preferences
          final token = snapshot.data!.getString(tokenKey);
          if (token == null) {
            return const AuthScreen();
          } else {
            // UserWrapper is a wrapper for the HomeScreen
            return UserWrapper(token);
          }
        } else if (snapshot.hasError) {
          return const MyErrorWidget();
        } else {
          return const SplashScreen();
        }
      },
      future: sharedPreferences,
    );
  }
}

class UserWrapper extends ConsumerStatefulWidget {
  const UserWrapper(this.token, {super.key});
  final String token;

  @override
  ConsumerState<UserWrapper> createState() => _UserWrapperState();
}

class _UserWrapperState extends ConsumerState<UserWrapper> {
  @override
  Widget build(BuildContext context) {
    // userFutureProvider is a FutureProvider that makes a request to the server
    // and returns the AppUser
    final user = ref.watch(userFutureProvider(widget.token));
    return user.when(
      data: (data) {
        return const HomeScreen();
      },
      error: (error, stackTrace) {
        return const HomeErrorScreen();
      },
      loading: () => const SplashScreen(),
    );
  }
}
