import 'package:SwishLab/controllers/dropdown_controller.dart';
import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:flutter/material.dart';

class Dropdown<T> extends StatefulWidget {
  final DropdownController<T> controller;
  final List<T> options;
  final ValueChanged<T?>? onChanged;
  final String hintText;

  const Dropdown({
    super.key,
    required this.controller,
    required this.options,
    this.onChanged,
    this.hintText = '',
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
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return DropdownButtonFormField<T>(
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
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: appColors.primaryBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appColors.altContBorders, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appColors.altContBorders, width: 2),
        ),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: appColors.secondaryText,
        size: 24,
      ),
      style: AppTextStyles.bodyMedium(context),
      elevation: 10,
    );
  }
}
