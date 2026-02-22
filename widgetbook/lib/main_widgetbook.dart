import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_ws/main_widgetbook.directories.g.dart';
import 'package:widgetbook_ws/widgetbook_theme_wrapper.dart';

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
      appBuilder: (context, child) {
        return WidgetbookThemeWrapper(child: child);
      },
      directories: directories,
    );
  }
}
