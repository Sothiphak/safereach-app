import 'package:flutter/material.dart';

class AppColors {
  // Neumorphic Soft Light Palette
  static const Color background = Color(0xFFE0E8F6); // Soft Slate Silver-Blue
  static const Color surface = Color(
    0xFFE0E8F6,
  ); // Must match background for Neumorphic blends
  static const Color primary = Color(
    0xFF4F46E5,
  ); // Royal Indigo (Interactive Accent)
  static const Color secondary = Color(0xFF0EA5E9); // Sky Blue
  static const Color accent = Color(0xFF06B6D4);
  static const Color border = Color(0xFFCBD5E1);

  static const Color lightShadow = Color(0xFFFFFFFF);
  static const Color darkShadow = Color(0xFFB8C4DA);

  // Neumorphic Soft Dark Palette
  static const Color darkBackground = Color(
    0xFF1A1F2C,
  ); // Soft Dark Charcoal Navy
  static const Color darkSurface = Color(
    0xFF1A1F2C,
  ); // Must match dark background
  static const Color darkLightShadow = Color(0xFF242B3D); // Soft Top-Left Glow
  static const Color darkDarkShadow = Color(
    0xFF10131B,
  ); // Soft Bottom-Right Shadow
  static const Color darkBorder = Color(0xFF334155);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Typography Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}
