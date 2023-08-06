import 'package:flutter/material.dart';
import 'package:journalbot/utils/theme.dart';

TextStyle titleTextStyle(MyTheme theme, {double? fontSize}) {
  return TextStyle(
    color: theme.onBackgroundColor,
    fontSize: fontSize ?? 20,
    fontWeight: FontWeight.w300,
  );
}
