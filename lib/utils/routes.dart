import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skybook/screens/auth_screen.dart';
import 'package:skybook/screens/books_screens/book_screen.dart';
import 'package:skybook/screens/books_screens/create_password_screen.dart';
import 'package:skybook/screens/home_screens/home_screen.dart';
import 'package:skybook/wrapper.dart';

import '../model/book_model.dart';
import '../model/page_model.dart';
import '../screens/about_page.dart';
import '../screens/books_screens/password_screen.dart';
import '../screens/page_screen/page_screen.dart';

class MyRouter {
  // All the routes in the app
  static const homeRoute = '/home';
  static const authRoute = '/auth';
  static const bookRoute = '/book';
  static const pageRoute = '/page';
  static const createUpdatePasswordRoute = '/createUpdatePassword';
  static const passwordRoute = '/password';
  static const aboutUsRoute = '/aboutUs';
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
      // Book route - BookScreen
      GoRoute(
        name: bookRoute,
        path: bookRoute,
        builder: (context, state) {
          Book book = state.extra as Book;
          return BookScreen(book: book);
        },
      ),
      // Page route - PageScreen
      GoRoute(
        name: pageRoute,
        path: pageRoute,
        builder: (context, state) {
          List<dynamic> list = state.extra as List<dynamic>;
          PageModel page = list[0] as PageModel;
          String bookId = list[1] as String;
          return PageScreen(page: page, bookId: bookId);
        },
      ),
      // CreateUpdatePassword route - CreateUpdatePasswordScreen
      GoRoute(
        name: createUpdatePasswordRoute,
        path: createUpdatePasswordRoute,
        pageBuilder: (context, state) {
          final arr = state.extra as List<dynamic>;
          final book = arr[0] as Book;
          final isCreate = arr[1] as bool;
          return customTransitionPage(
            CreateUpdatePasswordScreen(book: book, isCreate: isCreate),
            key: state.pageKey,
          );
        },
      ),
      // Password route - PasswordScreen
      GoRoute(
        name: passwordRoute,
        path: passwordRoute,
        pageBuilder: (context, state) {
          final book = state.extra as Book;
          return customTransitionPage(
            PasswordScreen(book: book),
            key: state.pageKey,
          );
        },
      ),
      // AboutUs route - AboutUsScreen
      GoRoute(
        name: aboutUsRoute,
        path: aboutUsRoute,
        pageBuilder: (context, state) {
          return customTransitionPage(
            const AboutUsScreen(),
            key: state.pageKey,
          );
        },
      ),
    ],
  );
  // CUstom transition used for all the routes
  static CustomTransitionPage customTransitionPage(Widget child,
      {required LocalKey key}) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
