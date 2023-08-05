import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Something went wrong",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
            Text(
              "😔",
              style: TextStyle(
                fontSize: 100.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
