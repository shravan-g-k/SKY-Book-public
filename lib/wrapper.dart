import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skybook/const.dart';
import 'package:skybook/repository/auth_repo.dart';
import 'package:skybook/screens/auth_screen.dart';
import 'package:skybook/screens/home_screens/home_error_screen.dart';
import 'package:skybook/screens/home_screens/home_screen.dart';
import 'package:skybook/common/pages/error_screen.dart';
import 'package:skybook/common/pages/splash_screen.dart';
import 'package:skybook/utils/theme.dart';

class Wrapper extends ConsumerStatefulWidget {
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
 

  @override
  Widget build(BuildContext context) {
    return ref.watch(sharedPreferencesProvider).when(
          data: (sharedPreferences) {
             
              // Get the token from the shared preferences
              final token = sharedPreferences.getString(tokenKey);
              if (token == null) {
                return const AuthScreen();
              } else {
                // UserWrapper is a wrapper for the HomeScreen
                return UserWrapper(token);
              }
            
          },
          error: (error, stackTrace) {
            return const MyErrorWidget();
          },
          loading: () => const SplashScreen(),
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
