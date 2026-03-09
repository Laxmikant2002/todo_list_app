import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevent instantiation

  // Backgrounds
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F5F5); // Light gray for cards

  // Text colors
  static const Color textPrimary = Color(
    0xFF212121,
  ); // Dark gray (almost black)
  static const Color textSecondary = Color(0xFF757575); // Medium gray
  static const Color textHint = Color(0xFFBDBDBD); // Light gray for hints

  // Primary accent (vibrant blue)
  static const Color primary = Color(0xFF2962FF);
  static const Color primaryLight = Color(0xFF768FFF);
  static const Color primaryDark = Color(0xFF0039CB);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFC107);

  // Borders and dividers
  static const Color border = Color(0xFFE0E0E0);

  // On‑colors (for text/icons on colored backgrounds)
  static const Color onPrimary = Colors.white;
  static const Color onBackground = textPrimary;
  static const Color onSurface = textPrimary;
  static const Color onError = Colors.white;
}
