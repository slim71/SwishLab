import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import 'settings_item.dart';

class SettingsRow extends StatelessWidget {
  final SettingsItem item;
  final bool showSeparator;

  const SettingsRow({
    required this.item,
    this.showSeparator = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppThemeManager.notifier,
      builder: (_, __, ___) {
        final bool isDarkColor = item.background.computeLuminance() < 0.5;
        final Color contentColor = isDarkColor ? Colors.white : Colors.black87;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: item.background.withValues(alpha: 0.9),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  item.onTap?.call(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (item.icon != null) ...[
                        Icon(
                          item.icon,
                          color: contentColor,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTextStyles.titleMedium(
                            context,
                            color: contentColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: contentColor.withValues(alpha: 0.5),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (showSeparator)
              Padding(
                padding: const EdgeInsets.only(left: 56, right: 20),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: contentColor.withValues(alpha: 0.1),
                ),
              ),
          ],
        );
      },
    );
  }
}
