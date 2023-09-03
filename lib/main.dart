import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skybook/utils/routes.dart';
import 'package:skybook/utils/theme.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: skybook(),
    ),
  );
  await Firebase.initializeApp();
}

class skybook extends ConsumerWidget {
  const skybook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(brightnessNotifierProvider);
    return MaterialApp.router(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 89, 0, 255),
            brightness: brightness,
          ),
          textTheme: const TextTheme(
            titleLarge: titleTextStyle,
            titleMedium: titleTextStyle,
            titleSmall: titleTextStyle,
            bodyLarge: titleTextStyle,
            bodyMedium: titleTextStyle,
            bodySmall: titleTextStyle,
            headlineLarge: titleTextStyle,
            headlineMedium: titleTextStyle,
            headlineSmall: titleTextStyle,
            displayLarge: titleTextStyle,
            displayMedium: titleTextStyle,
            displaySmall: titleTextStyle,
            labelLarge: titleTextStyle,
            labelMedium: titleTextStyle,
            labelSmall: titleTextStyle,
          )),
      routerConfig: MyRouter.routerConfig,
      title: 'Journal Bot',
    );
  }
}
