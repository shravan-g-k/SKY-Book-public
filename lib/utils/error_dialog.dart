import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalbot/utils/theme.dart';

// Error dialog
void errorDialog({
  required BuildContext context,
  required Ref ref,
  String title = "Something went wrong",
  String content = "Please try again later",
}) {
  final theme = ref.watch(themeProvider);
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.secondaryColor,
          title: Text(
            title,
            style: TextStyle(
              color: theme.onSecondaryColor,
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              color: theme.onSecondaryColor,
              fontSize: 16,
            ),
          ),
        );
      });
}
