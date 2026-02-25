import 'package:SwishLab/logger.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:flutter/cupertino.dart';

enum AppBrightness { system, light, dark }

/// Singleton manager for current theme colors
class AppThemeManager extends ChangeNotifier {
  AppThemeManager._();

  static final AppThemeManager instance = AppThemeManager._();

  static AppColorSet currentColors = theBay;
  static AppBrightness brightness = AppBrightness.system;
  static final logger = AppLogger.scope('AppThemeManager');

  // Used by Widgetbook / app root to rebuild
  static final ValueNotifier<int> notifier = ValueNotifier(0);

  static void _notify() {
    notifier.value++;
  }

  static void setBrightness(AppBrightness newBrightness) {
    if (brightness == newBrightness) return; // prevents useless rebuilds
    logger.d("setting brightness to $newBrightness");
    brightness = newBrightness;
    _notify();
  }

  static void setColors(AppColorSet newColors) {
    if (currentColors == newColors) return; // prevents useless rebuilds
    logger.d("setting colors to $newColors");
    currentColors = newColors;
    _notify();
  }

  static bool get isDark {
    switch (brightness) {
      case AppBrightness.light:
        return false;
      case AppBrightness.dark:
        return true;
      case AppBrightness.system:
        final windowBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return windowBrightness == Brightness.dark;
    }
  }

  static Color get primaryBackground => isDark ? primaryBackgroundDark : primaryBackgroundLight;

  static Color get secondaryBackground => isDark ? secondaryBackgroundDark : secondaryBackgroundLight;

  static Color get primaryText => isDark ? primaryTextDark : primaryTextLight;

  static Color get secondaryText => isDark ? secondaryTextDark : secondaryTextLight;
}
