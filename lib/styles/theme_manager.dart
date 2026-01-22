import 'package:SwishLab/styles/colors.dart';

/// Singleton manager for current theme colors
class AppThemeManager {
  static AppColorSet currentColors = theBay;

  static void setColors(AppColorSet newColors) {
    currentColors = newColors;
  }
}
