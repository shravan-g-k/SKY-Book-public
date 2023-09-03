import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1A1A1A),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/sky-logo.png',
                height: 200,
              ),
              const Text(
                'SKY Book',
                style: TextStyle(
                  color: Color(0xFFE5E5E5),
                  fontSize: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
