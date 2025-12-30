import 'package:SwishLab/styles/colors.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/widgets/settings_item.dart';
import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final SettingsItem item;

  const SettingsRow({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorSet>()!;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: item.onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: item.background,
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.title,
                style: AppTextStyles.titleLarge(context),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: appColors.secondaryText,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
