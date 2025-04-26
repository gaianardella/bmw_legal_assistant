import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();
  
  // Font settings
  static final _baseTextTheme = TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.0,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.4,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.4,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.2,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.2,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.2,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
  );

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.bmwBlue,
      onPrimary: Colors.white,
      secondary: AppColors.accentBlue,
      onSecondary: Colors.white,
      error: AppColors.errorRed,
      onError: Colors.white,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textDark,
      surface: Colors.white,
      onSurface: AppColors.textDark,
      surfaceVariant: Colors.grey[100]!,
      onSurfaceVariant: AppColors.textMedium,
      outline: AppColors.borderLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.borderLight),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: _baseTextTheme.headlineMedium?.copyWith(
        color: AppColors.textDark,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textDark,
      ),
    ),
    textTheme: _baseTextTheme,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.bmwBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.errorRed),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        backgroundColor: AppColors.bmwBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        textStyle: _baseTextTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        side: BorderSide(color: AppColors.bmwBlue),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        foregroundColor: AppColors.bmwBlue,
        textStyle: _baseTextTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        foregroundColor: AppColors.bmwBlue,
        textStyle: _baseTextTheme.labelLarge,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderLight,
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[100],
      labelStyle: _baseTextTheme.labelMedium?.copyWith(
        color: AppColors.textMedium,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.bmwBlue,
      unselectedLabelColor: AppColors.textMedium,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2,
          color: AppColors.bmwBlue,
        ),
      ),
      labelStyle: _baseTextTheme.labelLarge,
      unselectedLabelStyle: _baseTextTheme.labelLarge,
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.bmwBlue,
      onPrimary: Colors.white,
      secondary: AppColors.accentBlue,
      onSecondary: Colors.white,
      error: AppColors.errorRed,
      onError: Colors.white,
      background: AppColors.backgroundDark,
      onBackground: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: Colors.white,
      surfaceVariant: Colors.grey[850]!,
      onSurfaceVariant: Colors.grey[300]!,
      outline: AppColors.borderDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.borderDark),
      ),
      color: AppColors.surfaceDark,
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: _baseTextTheme.headlineMedium?.copyWith(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    textTheme: _baseTextTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.bmwBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.errorRed),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        backgroundColor: AppColors.bmwBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        textStyle: _baseTextTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        side: BorderSide(color: AppColors.bmwBlue),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        foregroundColor: AppColors.bmwBlue,
        textStyle: _baseTextTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        foregroundColor: AppColors.bmwBlue,
        textStyle: _baseTextTheme.labelLarge,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[800],
      labelStyle: _baseTextTheme.labelMedium?.copyWith(
        color: Colors.white,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.bmwBlue,
      unselectedLabelColor: Colors.grey[400],
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2,
          color: AppColors.bmwBlue,
        ),
      ),
      labelStyle: _baseTextTheme.labelLarge,
      unselectedLabelStyle: _baseTextTheme.labelLarge,
    ),
  );
}