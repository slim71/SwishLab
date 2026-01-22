import 'package:SwishLab/widgets/icon_action_button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      lightTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      directories: [
        WidgetbookCategory(
          name: 'Buttons',
          children: [
            WidgetbookComponent(
              name: 'Icon buttons comparison',
              useCases: [
                WidgetbookUseCase(
                  name: 'IconButton (plain)',
                  builder: (context) => Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.paypal,
                        color: Color(0xFF1E273B),
                        size: 30,
                      ),
                      onPressed: () async {},
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'IconButton (wrapped)',
                  builder: (context) => Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.paypal),
                        iconSize: 30,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Custom IconActionButton',
                  builder: (context) => Center(
                    child: IconActionButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30,
                      borderWidth: 1,
                      size: 50,
                      icon: Icons.paypal,
                      iconColor: Color(0xFF1E273B),
                      iconSize: 30,
                      onPressed: () async {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
