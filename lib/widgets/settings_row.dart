import 'dart:ui';

import 'package:flutter/material.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import 'settings_item.dart';

class SettingsRow extends StatelessWidget {
  final SettingsItem item;

  const SettingsRow({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          // Determine if we should use light or dark text based on background luminance
          final bool isDarkColor = item.background.computeLuminance() < 0.5;
          final Color contentColor = isDarkColor ? Colors.white : Colors.black87;

          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: InkWell(
                  onTap: () {
                    item.onTap?.call(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // Using the high opacity you liked (90%), but now applying it to the row's color
                      color: item.background.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (isDarkColor ? Colors.white : Colors.black).withValues(alpha: 0.15),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (item.icon != null) ...[
                          Icon(
                            item.icon,
                            color: contentColor,
                            size: 26,
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
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
