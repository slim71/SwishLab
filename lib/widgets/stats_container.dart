import 'dart:ui';

import 'package:flutter/material.dart';

import '../functions/add_animation.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import 'dynamic_icon_image.dart';

class StatsContainer extends StatelessWidget {
  final Color borderColor;
  final String title;
  final String iconName;
  final String? text;

  const StatsContainer({
    required this.borderColor,
    required this.title,
    required this.iconName,
    this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return addAnimation(
              widget: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.42,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppThemeManager.secondaryBackground.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor.withValues(alpha: 0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Custom icon with subtle glow
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: borderColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: DynamicIconImage(
                            width: 42,
                            height: 48,
                            imageName: iconName,
                          ),
                        ),

                        // Some space
                        const SizedBox(height: 12),

                        // Title for the section
                        Text(
                          title,
                          style: AppTextStyles.labelSmall(context,
                                  color: AppThemeManager.primaryText.withValues(alpha: 0.5))
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Latest score
                        Text(
                          text ?? '0',
                          style: AppTextStyles.titleLarge(context, color: AppThemeManager.primaryText).copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              withFade: false,
              shake: const ShakeConfig(rotation: 0.087, hz: 3));
        });
  }
}
