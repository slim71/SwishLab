import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logger.dart';
import 'colors.dart';

enum AppBrightness { system, light, dark }

/// Singleton manager for current theme colors
class AppThemeManager extends ChangeNotifier {
  AppThemeManager._();

  static final AppThemeManager instance = AppThemeManager._();

  static AppColorSet currentColors = theBay;
  static AppBrightness brightness = AppBrightness.system;
  static final logger = AppLogger.scope('AppThemeManager');

  static const String _brightnessKey = 'theme_brightness';
  static const String _colorSetKey = 'theme_color_set';

  // Used by components to know when to rebuild
  static final ValueNotifier<int> notifier = ValueNotifier(0);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load brightness
    final bIndex = prefs.getInt(_brightnessKey);
    if (bIndex != null) {
      brightness = AppBrightness.values[bIndex];
    }

    // Load color set
    final setName = prefs.getString(_colorSetKey);
    if (setName != null) {
      currentColors = themeList.firstWhere((set) => set.name == setName, orElse: () => theBay);
    }

    _notify();
  }

  @visibleForTesting
  static void reset() {
    brightness = AppBrightness.system;
    currentColors = theBay;
    notifier.value = 0;
  }

  /// Resets the theme to system defaults
  static void clearPreferences() {
    brightness = AppBrightness.system;
    currentColors = theBay;
    _notify();
  }

  /// Public bridge to protected notifyListeners()
  void triggerRefresh() {
    notifyListeners();
  }

  static void _notify() {
    notifier.value++;
    // Notify through the singleton instance
    instance.triggerRefresh();
  }

  static void setBrightness(AppBrightness newBrightness) {
    if (brightness == newBrightness) return;
    logger.d("Setting brightness to $newBrightness");
    brightness = newBrightness;
    SharedPreferences.getInstance().then((prefs) => prefs.setInt(_brightnessKey, newBrightness.index));
    _notify();
  }

  static void setColors(AppColorSet newColors) {
    if (currentColors == newColors) return;
    logger.d("Setting colors to ${newColors.name}");
    currentColors = newColors;
    SharedPreferences.getInstance().then((prefs) => prefs.setString(_colorSetKey, newColors.name));
    _notify();
  }

  static bool get isDark {
    switch (brightness) {
      case AppBrightness.light:
        return false;
      case AppBrightness.dark:
        return true;
      case AppBrightness.system:
        try {
          return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
        } catch (_) {
          return false;
        }
    }
  }

  static Color get primaryBackground => isDark ? primaryBackgroundDark : primaryBackgroundLight;

  static Color get secondaryBackground => isDark ? secondaryBackgroundDark : secondaryBackgroundLight;

  static Color get primaryText => isDark ? primaryTextDark : primaryTextLight;

  static Color get secondaryText => isDark ? secondaryTextDark : secondaryTextLight;
}
