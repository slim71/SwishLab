import 'package:flutter/material.dart';

import '../controllers/dropdown_controller.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';

class Dropdown<T> extends StatefulWidget {
  final DropdownController<T> controller;
  final List<T> options;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final Color? fillColor;

  const Dropdown({
    super.key,
    required this.controller,
    required this.options,
    this.onChanged,
    this.hintText = '',
    this.fillColor,
  });

  @override
  State<Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<Dropdown<T>> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Theme(
              data: Theme.of(context).copyWith(
                // Background of the dropdown menu
                canvasColor: AppThemeManager.secondaryBackground,
                // Default text style for menu items
                dropdownMenuTheme: DropdownMenuThemeData(
                  textStyle: AppTextStyles.bodyMedium(context),
                ),
              ),
              child: DropdownButtonFormField<T>(
                initialValue: widget.controller.value,
                items: widget.options
                    .map(
                      (opt) => DropdownMenuItem<T>(
                        value: opt,
                        child: Text(opt.toString(), style: AppTextStyles.bodyMedium(context)),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    widget.controller.value = val;
                  });
                  widget.onChanged?.call(val);
                },
                // Style of the field itself
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  filled: widget.fillColor != null,
                  fillColor: widget.fillColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: appColors.dropDownBorders, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: appColors.dropDownBorders, width: 2),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppThemeManager.secondaryText,
                  size: 24,
                ),
                style: AppTextStyles.bodyMedium(context),
                elevation: 10,
              ));
        });
  }
}
