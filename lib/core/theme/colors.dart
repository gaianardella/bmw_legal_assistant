import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();
  
  // BMW Brand Colors
  static const Color bmwBlue = Color(0xFF1C69D4); // BMW primary blue
  static const Color accentBlue = Color(0xFF0653B6); // Darker blue
  static const Color lightBlue = Color(0xFFE6F0FF); // Very light blue for backgrounds
  
  // Risk Colors
  static const Color successGreen = Color(0xFF34C759);
  static const Color warningYellow = Color(0xFFFFCC00);
  static const Color errorRed = Color(0xFFFF3B30);
  
  // Neutral Colors
  static const Color textDark = Color(0xFF1D1D1F);
  static const Color textMedium = Color(0xFF6E6E73);
  static const Color textLight = Color(0xFFAEAEB2);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F7);
  static const Color backgroundDark = Color(0xFF1D1D1F);
  
  // Surface Colors
  static const Color surfaceDark = Color(0xFF2C2C2E);
  
  // Border Colors
  static const Color borderLight = Color(0xFFD1D1D6);
  static const Color borderDark = Color(0xFF38383A);
  
  // Gradient Colors
  static const List<Color> blueGradient = [
    Color(0xFF1C69D4),
    Color(0xFF0653B6),
  ];
  
  static const List<Color> greenGradient = [
    Color(0xFF34C759),
    Color(0xFF30B350),
  ];
  
  static const List<Color> yellowGradient = [
    Color(0xFFFFCC00),
    Color(0xFFFFAA00),
  ];
  
  static const List<Color> redGradient = [
    Color(0xFFFF3B30),
    Color(0xFFFF2D55),
  ];
}