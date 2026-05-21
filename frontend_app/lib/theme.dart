import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF7E4D2B);
  static const Color dark = Color(0xFF4A2C18);
  static const Color muted = Color(0xFF8B6D5A);
  static const Color background = Color(0xFFFCECD7);
  static const Color surface = Color(0xFFEBE8E5); // Matches input background
  static const Color buttonBg = Color(0xFF7E4D2B); // Rich brown button
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFECEAE6), // Beige-white background from screenshots
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.bold,
          color: AppColors.dark,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.bold,
          color: AppColors.dark,
        ),
      ),
    );
  }
}
