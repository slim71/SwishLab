import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:flutter/material.dart';

class SingleChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  const SingleChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: selected ? appColors.labelSelectedIconColor : appColors.labelUnselectedIconColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.bodyMedium(
              color: selected ? appColors.primaryTwo : Colors.white,
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: appColors.labelSelectedBackground,
      backgroundColor: appColors.labelUnselectedBackground,
      side: BorderSide(
        color: selected ? appColors.labelSelectedBorders : appColors.labelUnselectedBorders,
        width: 2,
      ),
      elevation: 10,
      shadowColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
