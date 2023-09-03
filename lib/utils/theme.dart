import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final brightnessNotifierProvider =
    StateNotifierProvider<BrightnessNotifier, Brightness>((ref) {
  return BrightnessNotifier();
});

class BrightnessNotifier extends StateNotifier<Brightness> {
  BrightnessNotifier() : super(Brightness.dark);

  void toggle() {
    state = state == Brightness.light ? Brightness.dark : Brightness.light;
  }
}

TextStyle titleTextStyle = GoogleFonts.nunito(
  fontSize: 20,
  fontWeight: FontWeight.w300,
);
