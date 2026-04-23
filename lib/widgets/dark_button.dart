import 'package:flutter/material.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';

class DarkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry iconPadding;
  final Widget? icon;
  final bool isLoading;
  final double borderRadius;

  final bool? iconValue;
  final Widget? onIcon;
  final Widget? offIcon;

  const DarkButton({
    required this.onPressed,
    required this.text,
    this.height = 40,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.iconPadding = EdgeInsets.zero,
    this.icon,
    this.isLoading = false,
    this.borderRadius = 8,
    this.iconValue,
    this.onIcon,
    this.offIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Container(
              color: Colors.transparent,
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.darkButtonBackground,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    side: BorderSide(
                      color: appColors.darkButtonBorders,
                      width: 2,
                    ),
                  ),
                  fixedSize: width != null ? Size(width!, height) : Size.fromHeight(height),
                  padding: padding,
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: appColors.darkButtonTextColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null || (onIcon != null && offIcon != null))
                            Padding(
                              padding: iconPadding,
                              child: _buildIcon(),
                            ),
                          if (icon != null || (onIcon != null && offIcon != null)) const SizedBox(width: 8),
                          Text(
                            text,
                            style: AppTextStyles.titleLarge(context, color: appColors.darkButtonTextColor),
                          ),
                        ],
                      ),
              ));
        });
  }

  Widget? _buildIcon() {
    if (onIcon != null && offIcon != null && iconValue != null) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final rotate = Tween<double>(begin: 0.75, end: 1.0).animate(animation);
          final scale = Tween<double>(begin: 0.8, end: 1.0).animate(animation);
          return RotationTransition(
            turns: rotate,
            child: ScaleTransition(
              scale: scale,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(iconValue),
          child: iconValue! ? onIcon! : offIcon!,
        ),
      );
    }
    return icon;
  }
}
