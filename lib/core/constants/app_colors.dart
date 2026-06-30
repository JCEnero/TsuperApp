import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF243B7A);
  static const darkNavy = Color(0xFF1D2F63);
  static const secondary = darkNavy;
  static const surface = Color(0xFFF8F9FC);
  static const white = Color(0xFFFFFFFF);
  static const gray100 = Color(0xFFF2F4F7);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray600 = Color(0xFF374151);
  static const ink = Color(0xFF111827);
  static const softInk = Color(0xFF6B7280);
  static const muted = Color(0xFF9CA3AF);
  static const success = Color(0xFF3E7B5E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFB14B5C);
  static const error = Color(0xFFB14B5C);
  // Aliases
  static const background = surface;
  static const accent = gray600;
  static const offWhite = Color(0xFFFCFDFF);

  // Blue ramp — for the polished blue/white experience.
  static const blueDeep = Color(0xFF18255B); // gradient end / deep shade
  static const blueBright = Color(0xFF4C6EF5); // lively accent blue
  static const blueSky = Color(0xFF7DA0FF); // soft highlight blue
  static const blueTint = Color(0xFFEDF1FB); // very light blue surface

  // Status accents tuned to sit beside the blue palette.
  static const onDuty = Color(0xFF12B886); // teal-emerald, analogous to blue
  static const onDutyTint = Color(0xFFE6F7F0); // light green pill background
  static const stop = Color(0xFFE8505B); // warm coral-red for destructive
}
