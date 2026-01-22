import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/dynamic_icon_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    final appColors = AppThemeManager.currentColors;

    return Container(
      width: MediaQuery.sizeOf(context).width * 0.4,
      height: 160,
      decoration: BoxDecoration(
        color: appColors.primaryBackground,
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
            style: AppTextStyles.titleMedium(),
            textAlign: TextAlign.center,
          ),

          // Latest score
          Text(
            text ?? '0',
            style: AppTextStyles.headlineMedium(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().shake(rotation: 0.087, hz: 3);
  }
}
