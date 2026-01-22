import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:flutter/material.dart';

class DebugItem extends StatelessWidget {
  const DebugItem({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onPressed,
  });

  final String title;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 5),
      child: Semantics(
        label: 'Debug item container',
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors.secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 0,
                color: appColors.containersBorders,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: appColors.primaryText,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
            child: Semantics(
              label: 'Debug item row',
              child: Row(
                children: [
                  /// Title
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Semantics(
                        label: 'Debug item title',
                        child: Text(
                          title,
                          style: AppTextStyles.bodyMedium(),
                        ),
                      ),
                    ),
                  ),

                  /// Button
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Semantics(
                          label: 'Debug item action button',
                          child: DarkButton(
                            onPressed: onPressed,
                            text: buttonText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
