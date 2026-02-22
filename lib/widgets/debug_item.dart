import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/box_with_shadow.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:flutter/material.dart';

class DebugItem extends StatelessWidget {
  const DebugItem({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onPressed,
    this.width,
  });

  final String title;
  final String buttonText;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Container(
              color: AppThemeManager.primaryBackground,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 5),
                child: Container(
                  width: width ?? double.infinity,
                  height: 60,
                  decoration: BoxWithShadow(
                    border: Border.all(color: AppThemeManager.primaryText),
                  ),
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.bodyMedium(),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Button
                      DarkButton(
                        onPressed: onPressed,
                        text: buttonText,
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
