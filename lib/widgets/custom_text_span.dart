import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:flutter/material.dart';

class CustomTextSpan extends TextSpan {
  CustomTextSpan({
    required BuildContext context,
    super.text,
    bool bold = false,
    bool italic = false,
    bool underline = false,
    Color? color,
    Color? backgroundColor,
    TextStyle? style,
    super.children,
    super.recognizer,
    super.mouseCursor,
  }) : super(
          style: (style ?? AppTextStyles.bodyMedium(context)).copyWith(
            fontWeight: bold ? FontWeight.bold : null,
            fontStyle: italic ? FontStyle.italic : null,
            decoration: underline ? TextDecoration.underline : null,
            color: color ?? Theme.of(context).colorScheme.onSurface,
            backgroundColor: backgroundColor ?? AppThemeManager.primaryBackground,
          ),
        );
}
