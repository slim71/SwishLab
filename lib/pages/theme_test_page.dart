import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/dropdown_controller.dart';
import '../styles/theme_manager.dart';
import '../styles/styles.dart';
import '../widgets/dark_button.dart';
import '../widgets/light_button.dart';
import '../widgets/transparent_button.dart';
import '../widgets/icon_action_button.dart';
import '../widgets/input_field.dart';
import '../widgets/drop_down.dart';
import '../widgets/single_choice_chip.dart';

class ThemeTestPage extends StatefulWidget {
  const ThemeTestPage({super.key});

  @override
  State<ThemeTestPage> createState() => _ThemeTestPageState();
}

class _ThemeTestPageState extends State<ThemeTestPage> {
  final _textController = TextEditingController(text: 'Sample input text');
  final _dropdownController = DropdownController<String>(value: 'Option 1');

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppThemeManager.notifier,
      builder: (context, _, __) {
        final colors = AppThemeManager.currentColors;

        return Scaffold(
          backgroundColor: AppThemeManager.primaryBackground,
          appBar: AppBar(
            backgroundColor: AppThemeManager.secondaryBackground,
            title: Text('Theme: ${colors.name}', style: AppTextStyles.titleLarge(context)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildColorSection(context, 'Primary Palette', [
                    _ColorBox('primaryOne', colors.primaryOne),
                    _ColorBox('primaryTwo', colors.primaryTwo),
                    _ColorBox('primaryThree', colors.primaryThree),
                  ]),
                  _buildColorSection(context, 'Alternate Palette', [
                    _ColorBox('alternateOne', colors.alternateOne),
                    _ColorBox('alternateTwo', colors.alternateTwo),
                    _ColorBox('alternateThree', colors.alternateThree),
                  ]),
                  _buildColorSection(context, 'Retro Palette', [
                    _ColorBox('retroOne', colors.retroOne),
                    _ColorBox('retroTwo', colors.retroTwo),
                    _ColorBox('retroThree', colors.retroThree),
                  ]),
                  const Divider(height: 48),
                  _buildWidgetSection(context, 'Button Styles', [
                    _WidgetPreview('Dark Button', DarkButton(onPressed: () {}, text: 'Dark Style')),
                    _WidgetPreview(
                        'Light Button',
                        LightButton(
                            onPressed: () {},
                            text: 'Light Style',
                            icon: const FaIcon(FontAwesomeIcons.basketball, size: 16))),
                    _WidgetPreview('Transparent', TransparentButton(onPressed: () {}, text: 'Transparent')),
                  ]),
                  _buildWidgetSection(context, 'Form Components', [
                    _WidgetPreview(
                        'Action Button', IconActionButton(const Icon(Icons.add), onPressed: () {}, wrapped: true)),
                    _WidgetPreview('Input Field', InputField(controller: _textController, label: 'Label Text')),
                    _WidgetPreview('Dropdown',
                        Dropdown<String>(controller: _dropdownController, options: const ['Option 1', 'Option 2'])),
                  ]),
                  _buildWidgetSection(context, 'Label States', [
                    _WidgetPreview('Selected Chip',
                        SingleChoiceChip(label: 'Selected', selected: true, onTap: () {}, icon: Icons.check_circle)),
                    _WidgetPreview(
                        'Unselected Chip',
                        SingleChoiceChip(
                            label: 'Unselected', selected: false, onTap: () {}, icon: Icons.circle_outlined)),
                  ]),
                  _buildWidgetSection(context, 'Containers & Borders', [
                    _WidgetPreview(
                        'Main Border',
                        Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            color: AppThemeManager.secondaryBackground,
                            border: Border.all(color: colors.containersBorders, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(child: Text('ContainersBorders')),
                        )),
                    _WidgetPreview(
                        'Alt Border',
                        Container(
                          height: 100,
                          width: 150,
                          decoration: BoxDecoration(
                            color: AppThemeManager.secondaryBackground,
                            border: Border.all(color: colors.altContBorders, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(child: Text('AltContBorders')),
                        )),
                  ]),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorSection(BuildContext context, String title, List<_ColorBox> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(title, style: AppTextStyles.titleLarge(context)),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) => _buildColorPreview(context, item)).toList(),
        ),
      ],
    );
  }

  Widget _buildColorPreview(BuildContext context, _ColorBox item) {
    final color = item.color ?? Colors.transparent;
    final isDark = color.computeLuminance() < 0.5;

    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppThemeManager.secondaryText.withValues(alpha: 0.1)),
          ),
          child: Center(
            child: Text(
              '#${color.toARGB32().toRadixString(16).toUpperCase().substring(2)}',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(item.name, style: AppTextStyles.labelSmall(context)),
      ],
    );
  }

  Widget _buildWidgetSection(BuildContext context, String title, List<_WidgetPreview> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
          child: Text(title, style: AppTextStyles.titleLarge(context)),
        ),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: AppTextStyles.labelSmall(context, color: AppThemeManager.secondaryText)),
                  const SizedBox(height: 8),
                  item.widget,
                ],
              ),
            )),
      ],
    );
  }
}

class _ColorBox {
  final String name;
  final Color? color;
  _ColorBox(this.name, this.color);
}

class _WidgetPreview {
  final String label;
  final Widget widget;
  _WidgetPreview(this.label, this.widget);
}
