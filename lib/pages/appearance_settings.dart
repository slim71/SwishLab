import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../state/app_state.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';

class AppearanceSettings extends ConsumerStatefulWidget {
  const AppearanceSettings({super.key});

  @override
  ConsumerState<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends ConsumerState<AppearanceSettings> {
  Future<void> _confirmColorSetChange(AppColorSet colorSet) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Color Set?'),
        content: Text(
          'Are you sure you want to change the color set to "${colorSet.name}"? This will update the entire app\'s appearance.',
          style: AppTextStyles.bodyLarge(ctx, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      AppThemeManager.setColors(colorSet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppThemeManager.notifier,
      builder: (context, _, __) {
        final currentBrightness = AppThemeManager.brightness;
        final currentColors = AppThemeManager.currentColors;

        return Scaffold(
          backgroundColor: AppThemeManager.primaryBackground,
          appBar: const MyAppBar(
            style: MyAppBarStyle.backButtonTitleCentered,
            title: 'Appearance',
          ),
          body: Background(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Theme Mode'),
                  _buildThemeModeItem('System', AppBrightness.system, Icons.brightness_auto_rounded, currentBrightness),
                  _buildThemeModeItem('Light', AppBrightness.light, Icons.light_mode_rounded, currentBrightness),
                  _buildThemeModeItem('Dark', AppBrightness.dark, Icons.dark_mode_rounded, currentBrightness),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Color Set'),
                  ...themeList.map((set) => _buildColorSetItem(set, currentColors)),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Analysis Display'),
                  _buildAnalysisToggle(
                    'Show Performance Profile',
                    'Display the radar chart in analysis results',
                    ref.watch(appStateProvider).showRadarChart == true,
                    (val) => ref.read(appStateProvider.notifier).setShowRadarChart(val),
                  ),
                  const SizedBox(height: 44),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalysisToggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppThemeManager.primaryText.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppThemeManager.primaryText.withValues(alpha: 0.05)),
        ),
        child: SwitchListTile.adaptive(
          title: Text(title, style: AppTextStyles.titleMedium(context)),
          subtitle: Text(subtitle, style: AppTextStyles.bodySmall(context, color: AppThemeManager.secondaryText)),
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppThemeManager.currentColors.primaryOne,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall(
          context,
          color: AppThemeManager.primaryText.withValues(alpha: 0.5),
        ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildThemeModeItem(String title, AppBrightness value, IconData icon, AppBrightness current) {
    final isSelected = value == current;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => AppThemeManager.setBrightness(value),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppThemeManager.currentColors.primaryTwo.withValues(alpha: 0.15)
                : AppThemeManager.primaryText.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppThemeManager.currentColors.primaryTwo.withValues(alpha: 0.5) : Colors.transparent,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? AppThemeManager.currentColors.primaryTwo : AppThemeManager.secondaryText),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium(context,
                      color: isSelected ? AppThemeManager.currentColors.primaryTwo : AppThemeManager.primaryText),
                ),
              ),
              if (isSelected) Icon(Icons.check_circle_rounded, color: AppThemeManager.currentColors.primaryTwo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSetItem(AppColorSet colorSet, AppColorSet current) {
    final isSelected = colorSet.name == current.name;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => _confirmColorSetChange(colorSet),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colorSet.primaryOne.withValues(alpha: 0.15)
                : AppThemeManager.primaryText.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? colorSet.primaryOne.withValues(alpha: 0.5) : Colors.transparent,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: colorSet.gradient(begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  colorSet.name,
                  style: AppTextStyles.titleMedium(context,
                      color: isSelected ? colorSet.primaryOne : AppThemeManager.primaryText),
                ),
              ),
              if (isSelected) Icon(Icons.check_circle_rounded, color: colorSet.primaryOne),
            ],
          ),
        ),
      ),
    );
  }
}
