import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1A2A5F);
  static const darkNavy = Color(0xFF0F1A3A);
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
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFB42318);
  static const error = Color(0xFFB42318);
  // Aliases
  static const background = surface;
  static const accent = primary;
  static const offWhite = Color(0xFFFCFDFF);

  // Blue ramp — for the polished blue/white experience.
  static const blueDeep = darkNavy; // gradient end / deep shade
  static const blueBright = primary; // unified navy accent
  static const blueSky = primary; // avoid light blue decorative accents
  static const blueTint = Color(0xFFD0D8E8); // darker blue tint surface

  // Status accents tuned to sit beside the blue palette.
  static const onDuty = Color(0xFF12B886); // teal-emerald, analogous to blue
  static const onDutyTint = gray100; // neutral status background
  static const stop = Color(0xFFE8505B); // warm coral-red for destructive
}
