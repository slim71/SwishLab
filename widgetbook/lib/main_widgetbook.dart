import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:SwishLab/styles/themes.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_ws/widgetbook_theme_wrapper.dart';
import 'package:widgetbook_ws/main_widgetbook.directories.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      themeMode: ThemeMode.system,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: buildTheme(theBay, Brightness.light)),
            WidgetbookTheme(name: 'Dark', data: buildTheme(theBay, Brightness.dark)),
          ],
        ),
      ],
      appBuilder: (context, child) => WidgetbookThemeWrapper(child: child),
      directories: directories,
    );
  }
}
