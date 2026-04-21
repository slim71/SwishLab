import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_manager.dart';

class AppTextStyles {
  // ========== DISPLAY ==========
  static TextStyle displayLarge(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 64,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle displayMedium(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 44,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle displaySmall(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  // ========== HEADLINE ==========
  static TextStyle headlineLarge(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle headlineMedium(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle headlineSmall(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  // ========== TITLE ==========
  static TextStyle titleLarge(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle titleMedium(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle titleSmall(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.interTight(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  // ========== BODY ==========
  static TextStyle bodyLarge(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bodyMedium(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bodySmall(
    BuildContext context, {
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    );
  }

  // ========== LABEL ==========
  static TextStyle labelLarge(
    BuildContext context, {
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? colors.lightButtonTextColor,
    );
  }

  static TextStyle labelMedium(
    BuildContext context, {
    Color? color,
  }) {
    final colors = AppThemeManager.currentColors;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? colors.lightButtonTextColor,
    );
  }

  static TextStyle labelSmall(
    BuildContext context, {
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
