import 'package:flutter/material.dart';

class AppTheme {
  // Deep purple accent color extracted from the image's "Dashboard" text
  static const Color primaryPurple = Color(0xFF5B456A);
  static const Color backgroundColor = Color(
    0xFFF5F5F5,
  ); // Light grey from image

  static const double _cardRadius =
      8.0; // Slightly sharper corners based on image

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,

      // AppBar Theme matching the image (White background, dark icons)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: false,
        elevation: 1, // Slight shadow
        iconTheme: IconThemeData(color: Colors.black54),
      ),

      // Card Theme matching the image placeholders
      cardTheme: CardThemeData(
        elevation: 0.5,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
          side: BorderSide(color: Colors.grey.shade200), // Subtle border
        ),
        color: Colors.white,
      ),

      // Text Theme to apply the purple to headings
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: primaryPurple,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: primaryPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
