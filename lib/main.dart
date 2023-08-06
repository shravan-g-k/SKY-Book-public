import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/utils/routes.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: JournalBot(),
    ),
  );
  await Firebase.initializeApp();
}

// TODO : Change the name of the class
class JournalBot extends StatelessWidget {
  const JournalBot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(useMaterial3: true),
      routerConfig: MyRouter.routerConfig,
      title: 'Journal Bot',
    );
  }
}
