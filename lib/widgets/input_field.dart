import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final String? Function(String?)? validator;
  final RegExp? regex;
  final List<TextInputFormatter> additionalFormatters;

  const InputField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.validator,
    this.regex,
    this.additionalFormatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: false,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      style: AppTextStyles.bodyLarge(context, color: appColors.textFieldText),
      validator: validator,
      inputFormatters: [
        // Optional regex filtering
        if (regex != null) FilteringTextInputFormatter.allow(regex!),

        ...additionalFormatters,
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.labelLarge(context,
            color: appColors.textFieldLabelText),
        filled: true,
        fillColor: appColors.textFieldBackground,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: appColors.textFieldBorders,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: appColors.textFieldBorders,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}
