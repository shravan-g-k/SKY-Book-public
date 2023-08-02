import 'package:flutter/material.dart';
import 'package:journalbot/utils/theme.dart';

// Error dialog
void errorDialog({
  required BuildContext context,
  required MyTheme theme,
  String title = "Something went wrong",
  String content = "Please try again later",
}) {
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
