import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:flutter/material.dart';

class LightButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry iconPadding;
  final Widget? icon;

  const LightButton({
    required this.onPressed,
    required this.text,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.iconPadding = EdgeInsets.zero,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.lightButtonBackground,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(
            color: appColors.lightButtonBorders,
            width: 2,
          ),
        ),
        fixedSize: Size.fromHeight(height),
        padding: padding,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null)
          Padding(
            padding: iconPadding,
            child: icon,
          ),
        if (icon != null) const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.titleLarge(context,
              color: appColors.lightButtonTextColor),
        ),
      ]),
    );
  }
}
