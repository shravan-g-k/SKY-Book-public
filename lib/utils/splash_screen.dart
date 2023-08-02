import 'package:flutter/material.dart';

class SplahScreen extends StatelessWidget {
  const SplahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1A1A1A),
        child: const Center(
          child: Text(
            'Journal Bot',
            style: TextStyle(
              color: Color(0xFFE5E5E5),
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }
}
