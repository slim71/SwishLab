import 'package:flutter/material.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/styles/themes.dart';

class WidgetbookThemeWrapper extends StatefulWidget {
  final Widget child;

  const WidgetbookThemeWrapper({super.key, required this.child});

  @override
  State<WidgetbookThemeWrapper> createState() => _WidgetbookThemeWrapperState();
}

class _WidgetbookThemeWrapperState extends State<WidgetbookThemeWrapper> {
  AppColorSet appColors = AppThemeManager.currentColors;
  Brightness brightness = AppThemeManager.currentColors.brightness;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: appColors.isDark ? Colors.black : Colors.white),
      child: MaterialApp(
        theme: buildTheme(appColors, brightness),
        home: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButton<AppColorSet>(
                  value: appColors,
                  onChanged: (newColors) {
                    setState(() {
                      appColors = newColors!;
                      brightness = newColors.brightness;
                      AppThemeManager.setColors(newColors);
                    });
                  },
                  items: themeList.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                ),
              ),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
