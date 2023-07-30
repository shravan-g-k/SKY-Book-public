import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateProvider((ref) {
  return MyTheme();
});

// All the themes Dark and Light are defined here
// Used shared preferences to store the theme mode
class MyTheme {
  ThemeMode? themeMode;
  SharedPreferences? sharedPreferences;
  late Color primaryColor;
  late Color onPrimaryColor;
  late Color secondaryColor;
  late Color onSecondaryColor;
  late Color backgroundColor;
  late Color onBackgroundColor;

// We are initializing the theme mode and the colors
// check if the user has already set the theme mode (that is stored in shared preferences)
// if not then we set the theme mode to dark(default)
  void init(SharedPreferences pref) async {
    sharedPreferences = pref; //setting the shared preferences
    bool? darkMode = sharedPreferences!.getBool(
        'darkTheme'); //getting the theme mode if it is set else will be null
    // darkMode -> true if dark theme else false
    // If theme mode is found to be light then we set the theme mode to light
    if (darkMode != null && !(darkMode)) {
      _setTheme(ThemeMode.light);
    } else {
      // Else in all case ie no theme mode found or it is dark already
      _setTheme(ThemeMode.dark);
    }
  }

// Used by this class only to set the theme mode and the colors
  void _setTheme(ThemeMode theme) {
    if (theme == ThemeMode.dark) {
      themeMode = ThemeMode.dark;
      sharedPreferences!.setBool('darkTheme', true);
      ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 89, 0, 255),
        brightness: Brightness.dark,
      );
      primaryColor = colorScheme.primary;
      onPrimaryColor = colorScheme.onPrimary;
      secondaryColor = colorScheme.secondary;
      onSecondaryColor = colorScheme.onSecondary;
      backgroundColor = colorScheme.background;
      onBackgroundColor = colorScheme.onBackground;
    } else {
      themeMode = ThemeMode.light;
      sharedPreferences!.setBool('darkTheme', false);
      ColorScheme colorScheme = ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 89, 0, 255),
        brightness: Brightness.light,
      );
      primaryColor = colorScheme.primary;
      onPrimaryColor = colorScheme.onPrimary;
      secondaryColor = colorScheme.secondary;
      onSecondaryColor = colorScheme.onSecondary;
      backgroundColor = colorScheme.background;
      onBackgroundColor = colorScheme.onBackground;
    }
  }

// Used By the UI to toggle the theme mode
// Calls the _setTheme() to set the theme mode
// If the theme mode is dark then we set it to light and vice versa
  void toggleTheme() {
    if (themeMode == ThemeMode.dark) {
      _setTheme(ThemeMode.light);
    } else {
      _setTheme(ThemeMode.dark);
    }
  }
}
