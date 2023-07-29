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
  late Color secondaryColor;
  late Color backgroundColor;
  late Color textColor;
  late Color iconColor;

// We are initializing the theme mode and the colors
// check if the user has already set the theme mode (that is stored in shared preferences)
// if not then we set the theme mode to dark(default)
  void init(SharedPreferences pref) async {
    sharedPreferences = pref;//setting the shared preferences
    bool? darkMode = sharedPreferences!.getBool('darkTheme');//getting the theme mode if it is set else will be null
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
      primaryColor = const Color.fromARGB(255, 0, 51, 102);
      secondaryColor = const Color.fromARGB(255, 102, 153, 204);
      backgroundColor = const Color.fromARGB(255, 0, 0, 0);
      textColor = const Color.fromARGB(255, 255, 255, 255);
      iconColor = const Color.fromARGB(255, 255, 255, 255);
    } else {
      themeMode = ThemeMode.light;
      sharedPreferences!.setBool('darkTheme', false);
      primaryColor = const Color.fromARGB(255, 0, 123, 255);
      secondaryColor = const Color.fromARGB(255, 76, 175, 79);
      backgroundColor = const Color.fromARGB(255, 255, 255, 255);
      textColor = const Color.fromARGB(255, 51, 51, 51);
      iconColor = const Color.fromARGB(255, 0, 0, 0);
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
