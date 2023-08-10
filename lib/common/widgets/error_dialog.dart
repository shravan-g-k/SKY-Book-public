import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Error dialog
void errorDialog({
  required BuildContext context,
  required Ref ref,
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
