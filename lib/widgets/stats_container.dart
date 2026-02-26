import 'package:flutter/material.dart';
import 'package:swish_lab/functions/add_animation.dart';
import 'package:swish_lab/styles/styles.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/widgets/dynamic_icon_image.dart';

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
          return Container(
              color: AppThemeManager.primaryBackground,
              child: addAnimation(
                  widget: Container(
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppThemeManager.secondaryBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 3),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Custom icon
                        DynamicIconImage(
                          width: 50,
                          height: 50,
                          imageName: iconName,
                        ),

                        // Some space
                        const SizedBox(height: 8),

                        // Title for the section
                        Text(
                          title,
                          style: AppTextStyles.titleMedium(context),
                          textAlign: TextAlign.center,
                        ),

                        // Latest score
                        Text(
                          text ?? '0',
                          style: AppTextStyles.headlineMedium(context),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  withFade: false,
                  shake: const ShakeConfig(rotation: 0.087, hz: 3)));
        });
  }
}
