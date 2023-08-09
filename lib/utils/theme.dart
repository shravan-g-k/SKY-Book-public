import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

const TextStyle titleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w300,
);
