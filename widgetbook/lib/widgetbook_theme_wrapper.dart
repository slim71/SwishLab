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
    return ValueListenableBuilder(
      valueListenable: AppThemeManager.notifier,
      builder: (_, _, _) {
        final theme = buildTheme();

        return Theme(
            data: theme,
            child: Material(
                color: AppThemeManager.primaryBackground,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<AppColorSet>(
                            value: AppThemeManager.currentColors,
                            onChanged: (newColors) {
                              if (newColors != null) {
                                AppThemeManager.setColors(newColors);
                              }
                            },
                            items: themeList
                                .map(
                                  (t) =>
                                  DropdownMenuItem(
                                    value: t,
                                    child: Text(t.name),
                                  ),
                            )
                                .toList(),
                          ),
                          const SizedBox(width: 16),
                          DropdownButton<AppBrightness>(
                            value: AppThemeManager.brightness,
                            onChanged: (newBrightness) {
                              if (newBrightness != null) {
                                AppThemeManager.setBrightness(newBrightness);
                              }
                            },
                            items: AppBrightness.values
                                .map(
                                  (b) =>
                                  DropdownMenuItem(
                                    value: b,
                                    child: Text(b.name),
                                  ),
                            )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: AppThemeManager.primaryBackground,
                        child: Center(
                          child: child,
                        ),
                      ),
                    ),
                  ],
                )));
      },
    );
  }
}
