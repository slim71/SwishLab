import 'package:flutter/material.dart';
import 'package:swish_lab/styles/styles.dart';
import 'package:swish_lab/styles/theme_manager.dart';

class CustomTextSpan extends TextSpan {
  CustomTextSpan(
    BuildContext context, {
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
