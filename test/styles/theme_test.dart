import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swish_lab/styles/colors.dart';
import 'package:swish_lab/styles/styles.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/styles/themes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AppThemeManager.reset();
  });

  group('AppColorSet', () {
    test('copyWith works including defaults', () {
      final base = theBay;
      final updated = base.copyWith(name: null);
      expect(updated.name, 'NotValid');

      final updated2 = base.copyWith(pOne: Colors.red);
      expect(updated2.primaryOne, Colors.red);
    });

    test('lerp works', () {
      final base = theBay;
      final other = bullCity;
      final lerped = base.lerp(other, 0.5);
      expect(lerped.name, other.name);
      expect(lerped.primaryOne, Color.lerp(base.primaryOne, other.primaryOne, 0.5));
    });

    test('lerp returns this if other is not AppColorSet', () {
      final base = theBay;
      final lerped = base.lerp(null, 0.5);
      expect(lerped, base);
    });

    test('gradients work', () {
      final base = theBay;
      expect(base.gradientBackground(), isA<LinearGradient>());
      expect(base.gradientCircle(), isA<LinearGradient>());
      expect(base.gradientText(), isA<LinearGradient>());
      expect(base.gradientLinear(), isA<LinearGradient>());
    });

    test('gradient with primaryThree works', () {
      const setWithThree = AppColorSet(
        name: "Test",
        primaryOne: Colors.red,
        primaryTwo: Colors.blue,
        primaryThree: Colors.green,
        alternateOne: Colors.black,
        alternateTwo: Colors.white,
        retroOne: Colors.black,
        retroTwo: Colors.white,
        darkButtonBorders: Colors.black,
        lightButtonBorders: Colors.white,
        transparentButtonBorders: Colors.black,
        darkButtonBackground: Colors.black,
        lightButtonBackground: Colors.white,
        transparentButtonBackground: Colors.black,
        darkButtonTextColor: Colors.white,
        lightButtonTextColor: Colors.black,
        transparentButtonTextColor: Colors.white,
        actionButtonBorders: Colors.black,
        textFieldBorders: Colors.black,
        dropDownBorders: Colors.black,
        labelSelectedBackground: Colors.black,
        labelSelectedBorders: Colors.black,
        labelUnselectedBackground: Colors.black,
        labelUnselectedBorders: Colors.black,
        containersBorders: Colors.black,
        altContBorders: Colors.black,
      );
      final grad = setWithThree.gradient(begin: Alignment.topLeft, end: Alignment.bottomRight);
      expect(grad.colors.length, 3);
      expect(grad.colors[1], Colors.green);
    });
  });

  group('AppThemeManager', () {
    test('init loads from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'theme_brightness': AppBrightness.dark.index,
        'theme_color_set': bullCity.name,
      });

      await AppThemeManager.init();
      expect(AppThemeManager.brightness, AppBrightness.dark);
      expect(AppThemeManager.currentColors.name, bullCity.name);
    });

    test('init handles orElse for unknown color set', () async {
      SharedPreferences.setMockInitialValues({
        'theme_color_set': 'UnknownSet',
      });

      await AppThemeManager.init();
      expect(AppThemeManager.currentColors, theBay);
    });

    test('setBrightness updates and notifies', () {
      int notifyCount = 0;
      AppThemeManager.instance.addListener(() => notifyCount++);

      AppThemeManager.setBrightness(AppBrightness.dark);
      expect(AppThemeManager.brightness, AppBrightness.dark);
      expect(notifyCount, 1);

      AppThemeManager.setBrightness(AppBrightness.dark);
      expect(notifyCount, 1);
    });

    test('setColors updates and notifies', () {
      int notifyCount = 0;
      AppThemeManager.instance.addListener(() => notifyCount++);

      AppThemeManager.setColors(bullCity);
      expect(AppThemeManager.currentColors, bullCity);
      expect(notifyCount, 1);

      AppThemeManager.setColors(bullCity);
      expect(notifyCount, 1);
    });

    test('isDark returns correct value', () {
      AppThemeManager.setBrightness(AppBrightness.light);
      expect(AppThemeManager.isDark, isFalse);

      AppThemeManager.setBrightness(AppBrightness.dark);
      expect(AppThemeManager.isDark, isTrue);

      AppThemeManager.setBrightness(AppBrightness.system);
      expect(AppThemeManager.isDark, isFalse);
    });

    test('getters return correct colors based on brightness', () {
      AppThemeManager.setBrightness(AppBrightness.light);
      expect(AppThemeManager.primaryBackground, primaryBackgroundLight);
      expect(AppThemeManager.secondaryBackground, secondaryBackgroundLight);
      expect(AppThemeManager.primaryText, primaryTextLight);
      expect(AppThemeManager.secondaryText, secondaryTextLight);

      AppThemeManager.setBrightness(AppBrightness.dark);
      expect(AppThemeManager.primaryBackground, primaryBackgroundDark);
      expect(AppThemeManager.secondaryBackground, secondaryBackgroundDark);
      expect(AppThemeManager.primaryText, primaryTextDark);
      expect(AppThemeManager.secondaryText, secondaryTextDark);
    });
  });

  group('Themes and Styles', () {
    testWidgets('buildTheme returns a ThemeData', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: Container()));
      final theme = buildTheme();
      expect(theme, isA<ThemeData>());

      // Test dark mode branch in buildTheme
      AppThemeManager.setBrightness(AppBrightness.dark);
      final darkTheme = buildTheme();
      expect(darkTheme.brightness, Brightness.dark);
    });

    testWidgets('AppTextStyles return TextStyles', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          expect(AppTextStyles.displayLarge(context), isA<TextStyle>());
          expect(AppTextStyles.displayMedium(context), isA<TextStyle>());
          expect(AppTextStyles.displaySmall(context), isA<TextStyle>());
          expect(AppTextStyles.headlineLarge(context), isA<TextStyle>());
          expect(AppTextStyles.headlineMedium(context), isA<TextStyle>());
          expect(AppTextStyles.headlineSmall(context), isA<TextStyle>());
          expect(AppTextStyles.titleLarge(context), isA<TextStyle>());
          expect(AppTextStyles.titleMedium(context), isA<TextStyle>());
          expect(AppTextStyles.titleSmall(context), isA<TextStyle>());
          expect(AppTextStyles.bodyLarge(context), isA<TextStyle>());
          expect(AppTextStyles.bodyMedium(context), isA<TextStyle>());
          expect(AppTextStyles.bodySmall(context), isA<TextStyle>());
          expect(AppTextStyles.labelLarge(context), isA<TextStyle>());
          expect(AppTextStyles.labelMedium(context), isA<TextStyle>());
          expect(AppTextStyles.labelSmall(context), isA<TextStyle>());

          // Test with provided colors
          expect(AppTextStyles.displayLarge(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.displayMedium(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.displaySmall(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.headlineLarge(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.headlineMedium(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.headlineSmall(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.titleLarge(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.titleMedium(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.titleSmall(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.bodyLarge(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.bodyMedium(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.bodySmall(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.labelLarge(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.labelMedium(context, color: Colors.red).color, Colors.red);
          expect(AppTextStyles.labelSmall(context, color: Colors.red).color, Colors.red);

          return Container();
        }),
      ));
    });
  });
}
