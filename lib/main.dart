import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/utils/routes.dart';
import 'package:journalbot/utils/theme.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: JournalBot(),
    ),
  );
  await Firebase.initializeApp();
}

// TODO : Change the name of the class
class JournalBot extends ConsumerWidget {
  const JournalBot({super.key});

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
          
        )
      ),

      routerConfig: MyRouter.routerConfig,
      title: 'Journal Bot',
    );
  }
}
