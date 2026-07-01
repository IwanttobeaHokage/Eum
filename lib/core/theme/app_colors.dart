import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — calm steel blue
  static const Color primary = Color(0xFF5B7FA6);
  static const Color primaryLight = Color(0xFFD6E4F0);
  static const Color primaryDark = Color(0xFF3D5A78);

  // Accent — soft sage green
  static const Color accent = Color(0xFF8EB5A3);
  static const Color accentLight = Color(0xFFD4EAE3);

  // Backgrounds
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEFF2F7);

  // Text
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFADB5BD);

  // Emotion spectrum (low-saturation, calm)
  static const Color emotionJoy = Color(0xFFFFD166);
  static const Color emotionCalm = Color(0xFF8EB5A3);
  static const Color emotionSad = Color(0xFF8BA7C7);
  static const Color emotionAnxious = Color(0xFFB5A8C8);
  static const Color emotionAngry = Color(0xFFD4927A);

  // Crisis / warning — amber-neutral, NOT red
  static const Color warning = Color(0xFFD4A84B);
  static const Color warningLight = Color(0xFFFDF3DC);
  static const Color warningDark = Color(0xFF9A7530);

  // Status
  static const Color success = Color(0xFF6BAE8E);
  static const Color divider = Color(0xFFE5E9F0);

  // Chart colors
  static const List<Color> chartPalette = [
    Color(0xFF5B7FA6),
    Color(0xFF8EB5A3),
    Color(0xFFD4A84B),
    Color(0xFFB5A8C8),
    Color(0xFF8BA7C7),
  ];
}
