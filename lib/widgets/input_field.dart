import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  });

  @override
  State<InputField> createState() => _InputField();
}

class _InputField extends State<InputField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: false,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.obscureText && !_isVisible,
      style: AppTextStyles.bodyLarge(context, color: appColors.textFieldText),
      validator: widget.validator,
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
        suffixIcon: widget.obscureText
            ? InkWell(
                onTap: () {
                  setState(() {
                    _isVisible = !_isVisible;
                  });
                },
                focusNode: FocusNode(skipTraversal: true),
                child: Icon(
                  _isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF757575),
                  size: 22,
                ),
              )
            : widget.suffixIcon,
      ),
    );
  }
}
