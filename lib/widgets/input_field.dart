import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final TextInputType keyboardType;
  final List<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final String? Function(String?)? validator;
  final RegExp? allowRegex;
  final RegExp? denyRegex;
  final List<TextInputFormatter> additionalFormatters;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final Color? fillColor;

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
    this.allowRegex,
    this.denyRegex,
    this.additionalFormatters = const [],
    this.suffixIcon,
    this.onChanged,
    this.fillColor,
  });

  @override
  State<InputField> createState() => _InputField();
}

class _InputField extends State<InputField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            autofocus: false,
            keyboardType: widget.keyboardType,
            autofillHints: widget.autofillHints,
            textCapitalization: widget.textCapitalization,
            obscureText: widget.obscureText && !_isVisible,
            style: AppTextStyles.bodyLarge(context, color: AppThemeManager.primaryText),
            validator: widget.validator,
            onChanged: widget.onChanged,
            enableSuggestions: !widget.obscureText,
            autocorrect: !widget.obscureText,
            inputFormatters: [
              // Optional regex filtering
              if (widget.allowRegex != null) FilteringTextInputFormatter.allow(widget.allowRegex!),
              if (widget.denyRegex != null) FilteringTextInputFormatter.deny(widget.denyRegex!),

              ...widget.additionalFormatters,
            ],
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: AppTextStyles.labelLarge(context, color: AppThemeManager.secondaryText),
              filled: widget.fillColor != null,
              fillColor: widget.fillColor,
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
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              suffixIcon: widget.obscureText
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      child: Icon(
                        _isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppThemeManager.secondaryText.withAlpha(0xCC), // ~80% opacity
                        size: 22,
                      ),
                    )
                  : widget.suffixIcon,
            ),
          );
        });
  }
}
