import 'package:flutter/material.dart';

// Error dialog
void errorDialog({
  required BuildContext context,
  String title = "Something went wrong",
  String content = "Please try again later",
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        );
      });
}
