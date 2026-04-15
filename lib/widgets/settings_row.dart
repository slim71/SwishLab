import 'package:flutter/material.dart';
import 'package:swish_lab/styles/styles.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/widgets/settings_item.dart';

class SettingsRow extends StatelessWidget {
  final SettingsItem item;

  const SettingsRow({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final opacityPercentage = 0.50;

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Container(
              color: AppThemeManager.primaryBackground,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                child: InkWell(
                  onTap: () {
                    item.onTap?.call(context);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: item.background.withAlpha((255 * opacityPercentage).round()),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.title,
                          style: AppTextStyles.titleLarge(context),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppThemeManager.secondaryText,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
