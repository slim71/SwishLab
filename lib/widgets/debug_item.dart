import 'package:flutter/material.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import 'box_with_shadow.dart';
import 'dark_button.dart';

class DebugItem extends StatelessWidget {
  const DebugItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.buttonText,
    required this.onPressed,
    this.width,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String buttonText;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppThemeManager.notifier,
      builder: (_, __, ___) {
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: Container(
            width: width ?? double.infinity,
            decoration: BoxWithShadow(
              borderRadius: BorderRadius.circular(16),
              shadowOffset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
              shadowColor: Colors.black.withValues(alpha: 0.05),
              border: Border.all(
                color: AppThemeManager.primaryText.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppThemeManager.primaryText.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: AppThemeManager.primaryText,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],

                // Title and Subtitle
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleMedium(context, color: AppThemeManager.primaryText),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: AppTextStyles.bodySmall(
                            context,
                            color: AppThemeManager.secondaryText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Button
                DarkButton(
                  onPressed: onPressed,
                  text: buttonText,
                  borderRadius: 10,
                  height: 36,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
