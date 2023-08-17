import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journalbot/screens/auth_screen.dart';
import 'package:journalbot/screens/books_screens/book_screen.dart';
import 'package:journalbot/screens/home_screens/home_screen.dart';
import 'package:journalbot/wrapper.dart';

import '../model/book_model.dart';

class MyRouter {
  // All the routes in the app
  static const homeRoute = '/home';
  static const authRoute = '/auth';
  static const bookRoute = '/book';
  //

  // The router config
  static final routerConfig = GoRouter(
    routes: [
      // Initial route '/' - Wrapper
      GoRoute(
        path: '/',
        builder: (context, state) => const Wrapper(),
      ),
      // Home route - HomeScreen
      GoRoute(
        name: homeRoute,
        path: homeRoute,
        pageBuilder: (context, state) =>
            customTransitionPage(const HomeScreen(), key: state.pageKey),
      ),
      // Auth route - AuthScreen
      GoRoute(
        name: authRoute,
        path: authRoute,
        pageBuilder: (context, state) {
          return customTransitionPage(const AuthScreen(), key: state.pageKey);
        },
      ),
      GoRoute(
        name: bookRoute,
        path : bookRoute,
        builder: (context, state) {
          Book book = state.extra as Book;
          return BookScreen(book: book);
        },
      )
    ],
  );
  // CUstom transition used for all the routes
  static CustomTransitionPage customTransitionPage(Widget child,
      {required LocalKey key}) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
