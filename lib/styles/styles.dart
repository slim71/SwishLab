import 'package:SwishLab/styles/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // ========== DISPLAY ==========
  static TextStyle displayLarge({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 64,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  static TextStyle displayMedium({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 44,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  static TextStyle displaySmall({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  // ========== HEADLINE ==========
  static TextStyle headlineLarge({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  static TextStyle headlineMedium({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  static TextStyle headlineSmall({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  // ========== TITLE ==========
  static TextStyle titleLarge({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  static TextStyle titleMedium({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  static TextStyle titleSmall({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.interTight(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? colors.primaryText,
    );
  }

  // ========== BODY ==========
  static TextStyle bodyLarge({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? colors.primaryText,
    );
  }

  static TextStyle bodyMedium({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? colors.primaryText,
    );
  }

  static TextStyle bodySmall({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? colors.primaryText,
    );
  }

  // ========== LABEL ==========
  static TextStyle labelLarge({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? colors.lightButtonTextColor,
    );
  }

  static TextStyle labelMedium({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? colors.lightButtonTextColor,
    );
  }

  static TextStyle labelSmall({
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? colors.lightButtonTextColor,
    );
  }
}
