import 'package:flutter/material.dart';

class AppColors {
  // Primary - Teal
  static const Color primary = Color(0xFF00897B);
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color primaryDark = Color(0xFF00695C);

  // Secondary - Green
  static const Color secondary = Color(0xFF43A047);
  static const Color secondaryLight = Color(0xFF76D275);
  static const Color secondaryDark = Color(0xFF2E7D32);

  // Accent
  static const Color accent = Color(0xFF00BCD4);

  // Background
  static const Color background = Color(0xFFF5F8F7);
  static const Color surface = Color(0xFFF0F4F3);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A2E2B);
  static const Color textSecondary = Color(0xFF4E6965);
  static const Color textHint = Color(0xFF9DB4B0);

  // Border
  static const Color border = Color(0xFFE0EDEB);

  // Status
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF039BE5);

  // Transaction
  static const Color income = Color(0xFF00897B);
  static const Color expense = Color(0xFFE53935);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00897B), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF00695C), Color(0xFF1B5E20)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Transparent
  static const Color transparent = Colors.transparent;
  static const Color overlay = Color(0x80000000);
}
