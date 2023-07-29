import 'package:flutter/material.dart';
import 'package:journalbot/screens/auth_page/auth.dart';

void main() {
  runApp(const JournalBot());
}

// TODO : Change the name of the class
class JournalBot extends StatelessWidget {
  const JournalBot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal Bot',
      home: const AuthScreen(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontSize: 32,
            color: Colors.yellow,
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
    );
  }
}
