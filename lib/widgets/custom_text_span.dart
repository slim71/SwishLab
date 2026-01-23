import 'package:SwishLab/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomTextSpan extends TextSpan {
  CustomTextSpan({
    super.text,
    bool bold = false,
    bool italic = false,
    bool underline = false,
    Color? color,
    TextStyle? style,
    super.children,
    super.recognizer,
    super.mouseCursor,
  }) : super(
          style: (style ?? AppTextStyles.bodyMedium()).copyWith(
            fontWeight: bold ? FontWeight.bold : null,
            fontStyle: italic ? FontStyle.italic : null,
            decoration: underline ? TextDecoration.underline : null,
            color: color, // TODO: default?
          ),
        );
}
