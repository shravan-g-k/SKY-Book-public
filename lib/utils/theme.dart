import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance().then((value) {
    if(value.getBool(darkModeKey) == null) {
      value.setBool(darkModeKey, true);
    }
    final brightness = value.getBool(darkModeKey) == true
        ? Brightness.dark
        : Brightness.light;
    ref.read(brightnessNotifierProvider.notifier).setBrightness(brightness);
    return value;

  });
});

final brightnessNotifierProvider =
    StateNotifierProvider<BrightnessNotifier, Brightness>((ref) {
  return BrightnessNotifier();
});

class BrightnessNotifier extends StateNotifier<Brightness> {
  BrightnessNotifier() : super(Brightness.dark);

  void toggle() {
    state = state == Brightness.light ? Brightness.dark : Brightness.light;
  }

  void setBrightness(Brightness brightness) {
    state = brightness;
  }
}

TextStyle titleTextStyle = GoogleFonts.nunito(
  fontSize: 20,
  fontWeight: FontWeight.w300,
);
