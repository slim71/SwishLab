import 'package:flutter/material.dart';
import 'package:swish_lab/styles/colors.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/styles/themes.dart';

class WidgetbookThemeWrapper extends StatelessWidget {
  final Widget child;

  const WidgetbookThemeWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeManager.instance,
      builder: (context, _) {
        final theme = buildTheme();
        final currentColors = AppThemeManager.currentColors;
        final currentBrightness = AppThemeManager.brightness;

        return Theme(
          data: theme,
          child: Scaffold(
            backgroundColor: AppThemeManager.primaryBackground,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: Theme.of(context).cardColor.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Color Set Selection
                      DropdownButton<String>(
                        value: currentColors.name,
                        underline: const SizedBox(),
                        onChanged: (setName) {
                          if (setName != null) {
                            final newSet = themeList.firstWhere((t) => t.name == setName);
                            AppThemeManager.setColors(newSet);
                          }
                        },
                        items: themeList.map((t) => DropdownMenuItem(
                          value: t.name,
                          child: Text(t.name, style: const TextStyle(fontSize: 12)),
                        )).toList(),
                      ),

                      const SizedBox(width: 24),

                      // Brightness Selection
                      DropdownButton<AppBrightness>(
                        value: currentBrightness,
                        underline: const SizedBox(),
                        onChanged: (newBrightness) {
                          if (newBrightness != null) {
                            AppThemeManager.setBrightness(newBrightness);
                          }
                        },
                        items: AppBrightness.values.map((b) => DropdownMenuItem(
                          value: b,
                          child: Text(b.name.toUpperCase(), style: const TextStyle(fontSize: 12)),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppThemeManager.primaryBackground,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
