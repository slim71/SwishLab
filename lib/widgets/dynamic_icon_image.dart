import 'package:flutter/material.dart';

/// Widget to display an icon from local assets.
/// Falls back to a default icon if the requested one is missing.
class DynamicIconImage extends StatelessWidget {
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
  String get _normalized => imageName.toLowerCase().replaceAll(' ', '_');

  @override
  Widget build(BuildContext context) {
    final assetPath = 'assets/icons/$_normalized.png';
    final defaultPath = 'assets/icons/default_icon.png';

    // TODO: maybe add network fallback if dynamic in the future
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) {
        // Fallback to default icon
        return Image.asset(
          defaultPath,
          width: width,
          height: height,
        );
      },
    );
  }
}
