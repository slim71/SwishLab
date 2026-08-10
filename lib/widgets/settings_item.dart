import 'package:flutter/material.dart';

class SettingsItem {
  final String title;
  final Color background;
  final IconData? icon;
  final Future<void> Function(BuildContext context)? onTap;

  const SettingsItem({
    required this.title,
    required this.background,
    this.icon,
    this.onTap,
  });
}
