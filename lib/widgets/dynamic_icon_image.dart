import 'package:flutter/material.dart';

import '../logger.dart';
import '../styles/theme_manager.dart';

/// Widget to display an icon from local assets.
/// Falls back to a default icon if the requested one is missing.
class DynamicIconImage extends StatelessWidget {
  static final _logger = AppLogger.scope('DynamicIconImage');
  final double? width;
  final double? height;
  final String imageName;

  const DynamicIconImage({
    super.key,
    this.width,
    this.height,
    required this.imageName,
  });

  // Normalize the name to match your asset naming convention
  String get _normalized => imageName.toLowerCase().trim().replaceAll(RegExp(r'[\s\-_]+'), '_');

  @override
  Widget build(BuildContext context) {
    final assetPath = 'assets/icons/$_normalized.png';
    final defaultPath = 'assets/icons/default_icon.png';

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Container(
              color: Colors.transparent,
              child: Image.asset(
                assetPath,
                width: width,
                height: height,
                errorBuilder: (_, __, ___) {
                  _logger.w('Icon not found: $assetPath. Falling back to $defaultPath');
                  // Fallback to default icon
                  return Image.asset(
                    defaultPath,
                    width: width,
                    height: height,
                  );
                },
              ));
        });
  }
}
