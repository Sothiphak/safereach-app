import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static TextStyle _fontStyle(
    String language, {
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    if (language == 'KH') {
      return TextStyle(
        fontFamily: 'GoogleSans',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle _headingStyle(
    String language, {
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    if (language == 'KH') {
      return TextStyle(
        fontFamily: 'GoogleSans',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
    return GoogleFonts.sora(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static ThemeData light(String language) {
    final colorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
      primaryContainer: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme(
        AppColors.textPrimary,
        AppColors.textSecondary,
        language,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: _headingStyle(
            language,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: _headingStyle(
            language,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: _headingStyle(
            language,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.background,
        disabledColor: Colors.grey.shade200,
        selectedColor: AppColors.primary.withValues(alpha: 0.1),
        secondarySelectedColor: AppColors.secondary.withValues(alpha: 0.1),
        labelStyle: _fontStyle(
          language,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.background,
        elevation: 0,
        indicatorColor: AppColors.primary.withValues(alpha: 0.08),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _fontStyle(
              language,
              fontSize: AppTextStyles.caption.fontSize ?? 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            );
          }
          return _fontStyle(
            language,
            fontSize: AppTextStyles.caption.fontSize ?? 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 24);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: _fontStyle(
          language,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  static ThemeData dark(String language) {
    final colorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      outline: AppColors.darkBorder,
      primaryContainer: AppColors.darkBackground,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _textTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
        language,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.darkTextPrimary,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: _headingStyle(
            language,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: _headingStyle(
            language,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: _headingStyle(
            language,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkBackground,
        disabledColor: Colors.black26,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        secondarySelectedColor: AppColors.secondary.withValues(alpha: 0.2),
        labelStyle: _fontStyle(
          language,
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _fontStyle(
              language,
              fontSize: AppTextStyles.caption.fontSize ?? 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            );
          }
          return _fontStyle(
            language,
            fontSize: AppTextStyles.caption.fontSize ?? 12,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(
            color: AppColors.darkTextSecondary,
            size: 24,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: _fontStyle(
          language,
          color: AppColors.darkTextSecondary,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary, String language) {
    if (language == 'KH') {
      return TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'GoogleSans',
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'GoogleSans',
          fontSize: AppTextStyles.display.fontSize,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'GoogleSans',
          fontSize: AppTextStyles.title.fontSize,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'GoogleSans',
          fontSize: AppTextStyles.subtitle.fontSize,
          fontWeight: FontWeight.w500,
          color: primary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'GoogleSans',
          fontSize: AppTextStyles.body.fontSize,
          fontWeight: FontWeight.normal,
          color: primary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'GoogleSans',
          fontSize: AppTextStyles.bodySmall.fontSize,
          fontWeight: FontWeight.normal,
          color: primary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'GoogleSans',
          fontSize: AppTextStyles.caption.fontSize,
          fontWeight: FontWeight.normal,
          color: secondary,
        ),
      );
    }
    return TextTheme(
      displayLarge: GoogleFonts.sora(
        textStyle: AppTextStyles.display.copyWith(color: primary, fontSize: 36),
      ),
      displayMedium: GoogleFonts.sora(
        textStyle: AppTextStyles.display.copyWith(color: primary),
      ),
      titleLarge: GoogleFonts.sora(
        textStyle: AppTextStyles.title.copyWith(color: primary),
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        textStyle: AppTextStyles.subtitle.copyWith(color: primary),
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        textStyle: AppTextStyles.body.copyWith(color: primary),
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        textStyle: AppTextStyles.bodySmall.copyWith(color: primary),
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        textStyle: AppTextStyles.caption.copyWith(color: secondary),
      ),
    );
  }
}
